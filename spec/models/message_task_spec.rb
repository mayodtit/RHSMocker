require 'spec_helper'

describe MessageTask do
  let!(:pha_role) { Role.find_by_name(:pha) || create(:role, name: :pha) }

  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :consult
    it_validates 'presence of', :message

    describe '#one_message_per_consult' do
      let!(:consult) { create(:consult) }

      context 'with an already open task' do
        let!(:other_task) { create(:message_task, consult: consult, role: pha_role) }

        it 'adds an error if there are any other open message tasks' do
          task = build(:message_task, consult: consult, role: pha_role)
          expect(task).to_not be_valid
          expect(task.errors[:consult_id]).to include("open MessageTask already exists for Consult #{consult.id}")
        end
      end

      it 'does not add an error when the message task is the only task' do
        expect(described_class.where(consult_id: consult.id)).to be_empty
        task = create(:message_task, consult: consult, role: pha_role)
        expect(task).to be_valid
      end
    end
  end

  describe 'defaults' do
    describe 'owner' do
      let(:pha) { create(:pha) }
      let(:member) { create(:member, :premium, pha: pha) }

      context 'PHAs not on_call?' do
        before do
          pha_role.stub(on_call?: false)
        end

        it "assigns the user's PHA when the role is not on call" do
          task = create(:message_task, consult: member.master_consult, role: pha_role)
          expect(task.owner).to eq(pha)
        end
      end
    end

    describe 'priority' do
      let!(:member) { create(:member, :premium) }

      context 'PHAs are on call' do
        before do
          pha_role.stub(on_call?: true)
        end

        context 'first message' do
          it "sets FIRST_MESSAGE_PRIORITY" do
            task = create(:message_task, consult: member.master_consult, role: pha_role)
            expect(task.priority).to eq(MessageTask::FIRST_MESSAGE_PRIORITY)
          end
        end

        context 'not first message' do
          let!(:message) { create(:message, consult: member.master_consult, user: member) }

          before do
            # remove task for other message to prevent two open tasks
            other_task = described_class.find_by_consult_id(member.master_consult.id)
            other_task.abandoner = Member.robot
            other_task.reason = 'closed for testing'
            other_task.abandon!
          end

          it "sets NTH_MESSAGE_PRIORITY" do
            task = create(:message_task, consult: member.master_consult, role: pha_role)
            expect(task.priority).to eq(MessageTask::NTH_MESSAGE_PRIORITY)
          end
        end
      end

      context 'PHAs not on call' do
        before do
          pha_role.stub(on_call?: false)
        end

        it 'sets AFTER_HOURS_MESSAGE_PRIORITY' do
          task = create(:message_task, consult: member.master_consult, role: pha_role)
          expect(task.priority).to eq(MessageTask::AFTER_HOURS_MESSAGE_PRIORITY)
        end
      end
    end
  end
end
