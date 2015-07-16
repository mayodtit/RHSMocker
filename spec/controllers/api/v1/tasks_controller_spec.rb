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
    controller.stub(:task_order) { 'due_at DESC' }
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      let(:tasks) { [build_stubbed(:task), build_stubbed(:task)] }

      it_behaves_like 'success'

      it 'returns tasks with the state parameter' do
        Task.stub(:where).with('state' => 'unassigned') do
          o = Object.new
          o.stub(:where).with(role_id: nurse_role.id) do
            o_o = Object.new
            o_o.stub(:includes).with(:member) do
              o_o_o = Object.new
              o_o_o.stub(:order).with('due_at DESC') { tasks }
              o_o_o
            end
            o_o
          end
          o
        end

        get :index, state: 'unassigned'
        body = JSON.parse(response.body, symbolize_names: true)
        body[:tasks].to_json.should == tasks.serializer(shallow: true).as_json.to_json
      end

      it 'doesn\'t permit other query parameters' do
        Task.stub(:where).with('state' => 'unassigned') do
          o = Object.new
          o.stub(:where).with(role_id: nurse_role.id) do
            o_o = Object.new
            o_o.stub(:includes).with(:member) do
              o_o_o = Object.new
              o_o_o.stub(:order).with('due_at DESC') { tasks }
              o_o_o
            end
            o_o
          end
          o
        end
        get :index, state: 'unassigned', due_at: 3.days.ago
      end
    end
  end

  describe 'GET queue' do
    def do_request
      get :queue
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      let(:tasks) { [build_stubbed(:task), build_stubbed(:task)] }

      it_behaves_like 'success'
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
      get :show, id: task.id
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
      get :current
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
      put :update, id: task.id, task: {state_event: 'abandon'}
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'task 404'

      context 'task exists' do
        before do
          Task.stub(:find) { task }
        end

        context 'reason abandoned is present' do
          it 'sets reason to reason abandoned' do
            task.should_receive(:update_attributes).with hash_including('reason' => 'poo')
            put :update, id: task.id, task: {reason_abandoned: 'poo'}
          end

          it 'removes reason abandoned' do
            task.should_receive(:update_attributes).with hash_not_including('reason_abandoned' => 'poo')
            put :update, id: task.id, task: {reason_abandoned: 'poo'}
          end
        end

        context 'state event is present' do
          context 'state event is abandon' do
            it 'sets the actor to the current user' do
              task.should_receive(:update_attributes).with(
                'state_event' => 'abandon',
                'abandoner' => user,
                'reason' => 'poo',
                'actor_id' => user.id,
                'pubsub_client_id' => nil
              )

              task.stub(:owner_id) { user.id }
              task.stub(:assignor_id) { user.id }
              put :update, id: task.id, task: {state_event: 'abandon', reason: 'poo'}
            end
          end
        end

        context 'owner id is present' do
          def do_request
            put :update, id: task.id, task: {owner_id: 2}
          end

          context 'owner id does not match task' do
            before do
              task.stub(:owner_id) { 3 }
            end

            it 'sets assignor_id to current user' do
              task.should_receive(:update_attributes).with hash_including('assignor_id' => user.id)
              do_request
            end
          end

          context 'owner id matches task' do
            before do
              task.stub(:owner_id) { 2 }
            end

            def do_request
              put :update, id: task.id, task: {owner_id: 2}
            end

            it 'does nothing' do
              task.should_receive(:update_attributes).with hash_excluding('assignor_id')
              do_request
            end
          end

          context 'task has no owner' do
            before do
              task.stub(:owner_id) { nil }
            end

            it 'sets assignor_id to current user' do
              task.should_receive(:update_attributes).with hash_including('assignor_id' => user.id)
              do_request
            end
          end
        end

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
  end
end
