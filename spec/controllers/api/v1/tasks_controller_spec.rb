require 'spec_helper'

describe Api::V1::TasksController do
  let(:user) do
    member = build_stubbed :member
    member.add_role :nurse
    member
  end

  let(:nurse_role) do
    Role.find_by_name! :nurse
  end

  let(:ability) { Object.new.extend(CanCan::Ability) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      let(:tasks) { [build_stubbed(:task), build_stubbed(:task)] }

      it_behaves_like 'success'

      it 'returns tasks with the state parameter' do
        Task.stub(:where).with('state' => 'unassigned') do
          o = Object.new
          o.stub(:includes).with(:member) do
            o_o = Object.new
            o_o.stub(:order).with('due_at, created_at ASC') do
              o_o_o = Object.new
              o_o_o.stub(:each).and_yield(tasks[0]).and_yield(tasks[1])
              o_o_o
            end
            o_o
          end
          o
        end

        get :index, auth_token: user.auth_token, state: 'unassigned'
        body = JSON.parse(response.body, symbolize_names: true)
        body[:tasks].to_json.should == tasks.serializer(shallow: true).as_json.to_json
      end

      it 'doesn\'t permit other query parameters' do
        Task.stub(:where).with('state' => 'unassigned') do
          o = Object.new
          o.stub(:includes).with(:member) do
            o_o = Object.new
            o_o.stub(:order).with('due_at, created_at ASC') do
              o_o_o = Object.new
              o_o_o.stub(:each).and_yield(tasks[0]).and_yield(tasks[1])
              o_o_o
            end
            o_o
          end
          o
        end
        get :index, auth_token: user.auth_token, state: 'unassigned', due_at: 3.days.ago
      end
    end
  end

  describe 'GET queue' do
    def do_request
      get :queue, auth_token: user.auth_token
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      let(:tasks) { [build_stubbed(:task), build_stubbed(:task)] }

      it_behaves_like 'success'

      it 'returns tasks for the current hcp' do
        Task.should_receive(:unassigned_and_owned).with(user) do
          o = Object.new
          o.stub(:includes).with(:member) do
            o_o = Object.new
            o_o.stub(:order).with('due_at, created_at ASC') do
              o_o_o = Object.new
              o_o_o.stub(:each).and_yield(tasks[0]).and_yield(tasks[1])
              o_o_o
            end
            o_o
          end
          o
        end

        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        body[:tasks].to_json.should == tasks.serializer(shallow: true).as_json.to_json
      end
    end
  end

  shared_examples 'task 404' do
    context 'task doesn\'t exist' do
      before do
        Task.stub(:find) { raise(ActiveRecord::RecordNotFound) }
      end

      it_behaves_like '404'
    end
  end

  describe 'GET show' do
    let(:task) { build_stubbed :task }

    def do_request
      get :show, auth_token: user.auth_token, id: task.id
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'task 404'

      context 'task exists' do
        before do
          Task.stub(:find) { task }
        end

        it_behaves_like 'success'

        it 'returns the task' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          body[:task].to_json.should == task.serializer.as_json.to_json
        end
      end
    end
  end

  describe 'GET current' do
    let(:task) { build_stubbed :task }

    def do_request
      get :current, auth_token: user.auth_token
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      context 'task doesn\'t exist' do
        before do
          Task.stub(:find_by_owner_id_and_state).with(user.id, 'claimed') { nil }
        end

        it_behaves_like 'success'
      end

      context 'task exists' do
        before do
          Task.stub(:find_by_owner_id_and_state).with(user.id, 'claimed') { task }
        end

        it_behaves_like 'success'

        it 'returns the task' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          body[:task].to_json.should == task.serializer.as_json.to_json
        end
      end
    end
  end

  describe 'PUT update' do
    let(:task) { build_stubbed :task }

    def do_request
      put :update, auth_token: user.auth_token, id: task.id, task: {state_event: 'abandon'}
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'task 404'

      context 'task exists' do
        before do
          Task.stub(:find) { task }
        end

        context 'state event is present' do
          it 'sets the actor and owner to the current user' do
            task.should_receive(:update_attributes).with(
              'state_event' => 'abandon',
              'abandoner' => user,
              'owner_id' => user.id
            )

            do_request
          end

          context 'and valid' do
            context 'update is valid' do
              before do
                task.stub(:update_attributes) { true }
              end

              it_behaves_like 'success'
            end

            context 'update is not valid' do
              before do
                task.stub(:update_attributes) { false }
              end

              it_behaves_like 'failure'
            end
          end
        end

        context 'state event is not present' do
          def do_request
            put :update, auth_token: user.auth_token, id: task.id
          end

          it_behaves_like 'failure'
        end
      end
    end
  end
end