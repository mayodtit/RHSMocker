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
              o_o_o.stub(:order).with('priority DESC, due_at ASC, created_at ASC') { tasks }
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
              o_o_o.stub(:order).with('priority DESC, due_at ASC, created_at ASC') { tasks }
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

      context 'not on call' do
        before do
          user.stub(:on_call?) { false }
        end

        it 'returns tasks for the current hcp' do
          Task.should_receive(:owned).with(user) do
            o = Object.new
            o.stub(:where).with(role_id: nurse_role.id) do
              o_o = Object.new
              o_o.stub(:includes).with(:member) do
                o_o_o = Object.new
                o_o_o.stub(:order).with('priority DESC, due_at ASC, created_at ASC') { tasks }
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

      context 'on call' do
        before do
          user.stub(:on_call?) { true }
        end

        context 'metadata says only inbound and unassigned' do
          before do
            Metadata.stub(:on_call_queue_only_inbound_and_unassigned?) { true }
          end

          it 'returns tasks for the current hcp' do
            Task.should_receive(:needs_triage).with(user) do
              o = Object.new
              o.stub(:where).with(role_id: nurse_role.id) do
                o_o = Object.new
                o_o.stub(:includes).with(:member) do
                  o_o_o = Object.new
                  o_o_o.stub(:order).with('priority DESC, due_at ASC, created_at ASC') { tasks }
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

        context 'metadata says everything' do
          before do
            Metadata.stub(:on_call_queue_only_inbound_and_unassigned?) { false }
          end

          it 'returns tasks for the current hcp' do
            Task.should_receive(:needs_triage_or_owned).with(user) do
              o = Object.new
              o.stub(:where).with(role_id: nurse_role.id) do
                o_o = Object.new
                o_o.stub(:includes).with(:member) do
                  o_o_o = Object.new
                  o_o_o.stub(:order).with('priority DESC, due_at ASC, created_at ASC') { tasks }
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

        context 'state event is present' do
          context 'state event is abandon' do
            it 'sets the actor to the current user' do
              task.should_receive(:update_attributes).with(
                'state_event' => 'abandon',
                'abandoner' => user
              )

              task.stub(:owner_id) { user.id }
              task.stub(:assignor_id) { user.id }
              put :update, id: task.id, task: {state_event: 'abandon'}
            end
          end

          context 'task does not have an owner' do
            before do
              task.stub(:owner_id) { nil }
            end

            context 'owner id is not present' do
              def do_request
                put :update, id: task.id, task: {state_event: 'start'}
              end

              it 'sets owner id to current user' do
                task.should_receive(:update_attributes).with hash_including('owner_id' => user.id)
                do_request
              end
            end

            context 'owner id is present' do
              def do_request
                put :update, id: task.id, task: {state_event: 'start', owner_id: 2}
              end

              it 'does nothing' do
                task.should_receive(:update_attributes).with hash_including('owner_id' => '2')
                do_request
              end
            end
          end

          context 'task has an owner' do
            before do
              task.stub(:owner_id) { 4 }
            end

            context 'owner id is not present' do
              def do_request
                put :update, id: task.id, task: {state_event: 'start'}
              end

              it 'does nothing' do
                task.should_receive(:update_attributes).with hash_excluding('owner_id')
                do_request
              end
            end

            context 'owner id is present' do
              def do_request
                put :update, id: task.id, task: {state_event: 'start', owner_id: 2}
              end

              it 'does nothing' do
                task.should_receive(:update_attributes).with hash_including('owner_id' => '2')
                do_request
              end
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
