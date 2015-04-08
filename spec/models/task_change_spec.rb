require 'spec_helper'

describe TaskChange do
  it_has_a 'valid factory'

  describe '#validations' do
    it_validates 'presence of', :task
    it_validates 'presence of', :actor
  end

  describe '#publish' do
    let(:task_change) { build_stubbed :task_change }
    let(:owner) { build_stubbed :pha }
    let(:actor) { build_stubbed :pha }

    shared_examples 'doesn\'t send pub sub notification' do
      it 'doesn\'t send a pub sub notification' do
        PubSub.should_not_receive :publish
        task_change.publish
      end
    end

    context 'event is update' do
      before do
        task_change.event = 'update'
      end

      context 'where owner id did not change' do
        before do
          task_change.data = {'description' => ['old', 'new']}
        end

        it_behaves_like 'doesn\'t send pub sub notification'
      end

      context 'where owner id did change' do
        before do
          task_change.data = {'owner_id' => [actor.id, owner.id]}
        end

        context 'where owner_id is not actor_id' do
          before do
            task_change.actor_id = actor.id
            task_change.actor = actor
          end

          context 'task type is MemberTask' do
            let(:service_type) { build_stubbed :service_type }

            before do
              task_change.task.stub(:type) { 'MemberTask' }
              task_change.task.stub(:service_type) { service_type }
            end

            it 'send a pub sub notification' do
              PubSub.should_receive(:publish).with "/users/#{task_change.task.owner_id}/notifications/tasks", {msg: "#{task_change.actor.first_name} assigned you a #{task_change.task.service_type.bucket} task", id: task_change.task.id, assignedTo: task_change.task.owner_id}
              task_change.publish
            end
          end

          context 'task type is PhoneCallTask' do
            before do
              task_change.task.stub(:type) { 'PhoneCallTask' }
            end

            it 'send a pub sub notification' do
              PubSub.should_receive(:publish).with "/users/#{task_change.task.owner_id}/notifications/tasks", {msg: "#{task_change.actor.first_name} assigned you to a call", id: task_change.task.id, assignedTo: task_change.task.owner_id}
              task_change.publish
            end
          end
        end
      end

      context 'where owner_id is actor_id' do
        before do
          task_change.actor_id = owner.id
          task_change.actor = actor
        end

        it_behaves_like 'doesn\'t send pub sub notification'
      end
    end

    context 'event is nil' do
      before do
        task_change.event = nil
      end

      context 'where owner is nil' do
        let(:on_call_pha) { build_stubbed :pha }
        let(:another_on_call_pha) { build_stubbed :pha }

        before do
          task_change.task.owner_id = nil
          Role.stub_chain(:pha, :id).and_return(task_change.task.role_id)
          Role.stub_chain(:pha, :users) do
            o = Object.new
            o.stub(:where).with(on_call: true) { [on_call_pha, another_on_call_pha] }
            o
          end
        end

        context 'task type is MemberTask' do
          let(:service_type) { build_stubbed :service_type }

          before do
            task_change.task.stub(:type) { 'MemberTask' }
            task_change.task.stub(:service_type) { service_type }
          end

          it 'sends a pub sub notification to all on call PHAs' do
            PubSub.should_receive(:publish).with "/users/#{on_call_pha.id}/notifications/tasks", {msg: "New #{task_change.task.service_type.bucket} task", id: task_change.task_id, assignedTo: task_change.task.owner_id}
            PubSub.should_receive(:publish).with "/users/#{another_on_call_pha.id}/notifications/tasks", {msg: "New #{task_change.task.service_type.bucket} task", id: task_change.task_id, assignedTo: task_change.task.owner_id}
            task_change.publish
          end
        end

        context 'task type is PhoneCallTask' do
          let(:service_type) { build_stubbed :service_type }

          before do
            task_change.task.stub(:type) { 'PhoneCallTask' }
            task_change.task.stub(:service_type) { service_type }
          end

          it 'send a pub sub notification' do
            PubSub.should_receive(:publish).with "/users/#{on_call_pha.id}/notifications/tasks", {msg: "New inbound phone call", id: task_change.task_id, assignedTo: task_change.task.owner_id}
            PubSub.should_receive(:publish).with "/users/#{another_on_call_pha.id}/notifications/tasks", {msg: "New inbound phone call", id: task_change.task_id, assignedTo: task_change.task.owner_id}
            task_change.publish
          end
        end
      end

      context 'where owner_id is not actor_id' do
        before do
          task_change.actor_id = actor.id
          task_change.actor = actor
          task_change.task.owner_id = 1
        end

        context 'task type is MemberTask' do
          let(:service_type) { build_stubbed :service_type }

          before do
            task_change.task.stub(:type) { 'MemberTask' }
            task_change.task.stub(:service_type) { service_type }
          end

          it 'send a pub sub notification' do
            PubSub.should_receive(:publish).with "/users/#{task_change.task.owner_id}/notifications/tasks", {msg: "#{task_change.actor.first_name} assigned you a #{task_change.task.service_type.bucket} task", id: task_change.task.id, assignedTo: task_change.task.owner_id}
            task_change.publish
          end
        end

        context 'task type is PhoneCallTask' do
          before do
            task_change.task.stub(:type) { 'PhoneCallTask' }
          end

          it 'send a pub sub notification' do
            PubSub.should_receive(:publish).with "/users/#{task_change.task.owner_id}/notifications/tasks", {msg: "#{task_change.actor.first_name} assigned you to a call", id: task_change.task.id, assignedTo: task_change.task.owner_id}
            task_change.publish
          end
        end
      end

      context 'where owner_id is actor_id' do
        before do
          task_change.actor_id = owner.id
          task_change.actor = actor
        end
        it_behaves_like 'doesn\'t send pub sub notification'
      end
    end

    context 'event is something else' do
      before do
        task_change.event = 'claim'
      end

      it_behaves_like 'doesn\'t send pub sub notification'
    end
  end
end
