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
            task = build_stubbed :message_task, :claimed, kind: 'message', consult: consult, role_id: @pha_id
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

      it 'creates a task with consult and message' do
        message = build(:message, consult: consult)
        MessageTask.should_receive(:create!).with(title: consult.title, consult: consult, message: message, creator: Member.robot, due_at: message.created_at)
        MessageTask.create_if_only_opened_for_consult!(consult, message)
      end

      it 'creates a task with just a consult' do
        MessageTask.should_receive(:create!).with(title: consult.title, consult: consult, message: nil, creator: Member.robot, due_at: consult.created_at)
        MessageTask.create_if_only_opened_for_consult!(consult)
      end
    end
  end
end
