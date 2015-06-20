require 'spec_helper'

describe MessageTask do
  before do
    @pha_id = Role.find_or_create_by_name!(:pha).id
  end

  describe 'validations' do
    it_validates 'presence of', :consult_id
    it_validates 'foreign key of', :message
    it_validates 'foreign key of', :consult

    describe '#one_message_per_consult' do
      let(:consult) { build_stubbed :consult }
      let(:task) { build :message_task, consult: consult }

      context 'and open' do
        context 'and message task for consult exists' do
          it 'should not be valid if task is different' do
            other_task = build_stubbed :message_task
            MessageTask.stub(:open) do
              o = Object.new
              o.stub(:where).with(consult_id: consult.id) do
                o = Object.new
                o.stub(:first) { other_task }
                o
              end
              o
            end
            task.should_not be_valid
          end

          it 'should be valid if task is the same' do
            task = build_stubbed :message_task, :claimed, consult: consult, role_id: @pha_id
            MessageTask.stub(:open) do
              o = Object.new
              o.stub(:where).with(consult_id: consult.id) do
                o = Object.new
                o.stub(:first) { task }
                o
              end
              o
            end
            task.should be_valid
          end
        end

        context 'and message task for consult DNE' do
          it 'should be valid' do
            MessageTask.stub(:open) do
              o = Object.new
              o.stub(:where).with(consult_id: consult.id) do
                o = Object.new
                o.stub(:first) { nil }
                o
              end
              o
            end
            task.should be_valid
          end
        end
      end

      context 'and not open' do
        before do
          task.stub(:open?) { false }
        end

        it 'should be valid' do
          task.should be_valid
        end
      end
    end
  end

  describe '#create_if_only_opened_for_consult!' do
    let(:consult) { build_stubbed(:consult) }

    context 'no message' do
      context 'other open message task exists for consult' do
        before do
          MessageTask.stub(:open) do
            o = Object.new
            o.stub(:where).with(consult_id: consult.id) do
              o = Object.new
              o.stub(:count) { 1 }
              o
            end
            o
          end
        end

        it 'does nothing' do
          MessageTask.should_not_receive(:create!)
          MessageTask.create_if_only_opened_for_consult!(consult)
        end
      end

      context 'other open message task doesn\'t exist for consult' do
        before do
          MessageTask.stub(:open) do
            o = Object.new
            o.stub(:where).with(consult_id: consult.id) do
              o = Object.new
              o.stub(:count) { 0 }
              o
            end
            o
          end
        end

        it 'creates a task' do
          MessageTask.should_receive(:create!).with(title: 'Inbound Message', consult: consult, message: nil, creator: Member.robot, due_at: consult.created_at)
          MessageTask.create_if_only_opened_for_consult!(consult)
        end
      end
    end

    context 'message' do
      context 'sender matches consult initiator' do
        let(:message) { build :message, consult: consult, user: consult.initiator }

        context 'other open message task exists for consult' do
          before do
            MessageTask.stub(:open) do
              o = Object.new
              o.stub(:where).with(consult_id: consult.id) do
                o = Object.new
                o.stub(:count) { 1 }
                o
              end
              o
            end
          end

          it 'does nothing' do
            MessageTask.should_not_receive(:create!)
            MessageTask.create_if_only_opened_for_consult!(consult, message)
          end
        end

        context 'other open message task doesn\'t exist for consult' do
          before do
            MessageTask.stub(:open) do
              o = Object.new
              o.stub(:where).with(consult_id: consult.id) do
                o = Object.new
                o.stub(:count) { 0 }
                o
              end
              o
            end
          end

          it 'creates a task with consult and message' do
            MessageTask.should_receive(:create!).with(title: 'Inbound Message', consult: consult, message: message, creator: Member.robot, due_at: message.created_at)
            MessageTask.create_if_only_opened_for_consult!(consult, message)
          end
        end
      end

      context 'sender is not consult initiator' do
        let(:message) { build :message, consult: consult, user: build(:pha) }

        before do
          MessageTask.stub(:open) do
            o = Object.new
            o.stub(:where).with(consult_id: consult.id) do
              o = Object.new
              o.stub(:count) { 0 }
              o
            end
            o
          end
        end

        it 'does nothing' do
          MessageTask.should_not_receive(:create!)
          MessageTask.create_if_only_opened_for_consult!(consult, message)
        end
      end
    end
  end

  describe '#set_priority' do
    let!(:consult) { create :consult }
    let!(:message) { create :message, consult: consult, user: consult.initiator }

    before do
      # Clear out any MessageTasks that are created through callbacks
      consult
      message
      MessageTask.destroy_all
    end

    context 'role is on call' do
      before do
        Role.any_instance.stub(:on_call?) { true }
      end

      context 'if this message is the first message' do
        let!(:task) { create :message_task, message: message, consult: consult }

        it 'sets the priority appropriately' do
          task.set_priority
          task.priority.should == MessageTask::FIRST_MESSAGE_PRIORITY
        end

        context 'member added multiple messages' do
          before do
            create :message, consult: consult, user: consult.initiator, created_at: 1.minute.from_now
            create :message, consult: consult, user: consult.initiator, created_at: 5.minutes.from_now
          end

          it 'sets the priority to what it should be for the first message' do
            task.set_priority
            task.priority.should == MessageTask::FIRST_MESSAGE_PRIORITY
          end
        end
      end

      context 'if this message is not the first message' do
        let!(:task) { create :message_task, message: message, consult: consult }

        before do
          create :message, consult: consult, user: consult.initiator, created_at: 3.days.ago
          create :message, consult: consult, user: consult.initiator, created_at: 5.minutes.ago
        end

        it 'sets the priority appropriately' do
          task.set_priority
          task.priority.should == MessageTask::NTH_MESSAGE_PRIORITY
        end
      end
    end

    context 'role is not on call' do
      let(:pha) { create :pha }
      let!(:task) { create :message_task, message: message, consult: consult }

      before do
        Role.any_instance.stub(:on_call?) { false }
        consult.initiator.update_attributes!(pha_id: pha.id)
      end

      it 'sets the priority appropriately' do
        task.set_priority
        task.priority.should == MessageTask::AFTER_HOURS_MESSAGE_PRIORITY
      end
    end
  end

  describe '#set_member' do
    let(:message) { build_stubbed :message }
    let(:message_task) { build_stubbed :message_task, message: message, consult: message.consult }

    it 'sets the member to the consult initiator' do
      message_task.member = nil
      message_task.set_member
      message_task.member.should == message.consult.initiator
    end
  end
end
