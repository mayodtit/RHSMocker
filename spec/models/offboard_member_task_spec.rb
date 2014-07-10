require 'spec_helper'

describe OffboardMemberTask do
  before do
    @service_type = ServiceType.find_or_create_by_name! name: 'member offboarding', bucket: 'engagement'
    @message_template = MessageTemplate.find_or_create_by_name! name: 'Offboard Engaged Member', text: 'test'
  end

  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'foreign key of', :member
    it_validates 'foreign key of', :service_type
  end

  describe '#set_required_attrs' do
    let(:task) { build :offboard_member_task }

    it 'sets title' do
      task.set_required_attrs
      task.title.should == "Offboard engaged free trial member"
    end

    it 'sets due_at to one hour before a person\'s free trial ends' do
      task.set_required_attrs
      task.due_at = task.member.free_trial_ends_at - 1.hour
    end

    it 'sets service type' do
      task.set_required_attrs
      task.service_type.should == @service_type
    end

    it 'sets the creator to the robot' do
      task.set_required_attrs
      task.creator.should == Member.robot
    end
  end

  describe '#create_scheduled_message' do
    let(:task) { build :offboard_member_task }
    let(:pha) { build :pha }
    let(:consult) { build :consult }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    it 'creates a scheduled message from a message template' do
      task.member.stub(:master_consult) { consult }
      task.member.stub(:free_trial_ends_at) { 3.days.ago }
      task.member.stub(:pha) { pha }

      MessageTemplate.should_receive(:find_by_name!).with('Offboard Engaged Member') { @message_template }
      @message_template.should_receive(:create_scheduled_message).with(pha, consult, task.member.free_trial_ends_at)
      task.create_scheduled_message
    end
  end

  describe '#create_if_only_within_offboarding_window' do
    let!(:pha) { create :pha }
    let!(:member) { create :member, free_trial_ends_at: Time.now, pha: pha }

    context 'an offboard task exists within the offboarding window' do
      context 'its for another member' do
        let!(:other_member) { create :member }
        let!(:offboard_task) { create :offboard_member_task, member: other_member }

        it 'creates an offboard task' do
          o = OffboardMemberTask.create_if_only_within_offboarding_window(member)
          o.should be_present
          o.should be_valid
        end
      end

      context 'its for the current member' do
        let!(:offboard_task) { create :offboard_member_task, member: member }

        shared_examples 'offboarding window' do
          context 'it was created outside the current offboarding window' do
            before do
              offboard_task.created_at = member.free_trial_ends_at - OffboardMemberTask::OFFBOARDING_WINDOW - 1.minute
              offboard_task.save!
            end

            it 'creates an offboard task' do
              o = OffboardMemberTask.create_if_only_within_offboarding_window(member)
              o.should be_present
              o.should be_valid
            end
          end

          context 'it was created during the current offboarding window' do
            it 'does not create an offboard task' do
              o = OffboardMemberTask.create_if_only_within_offboarding_window(member)
              o.should be_nil
            end
          end
        end

        context 'task is abandoned' do
          before do
            offboard_task.update_attributes! state_event: :abandon, abandoner: pha, reason_abandoned: 'test'
          end

          it_behaves_like 'offboarding window'
        end

        context 'task is completed' do
          before do
            offboard_task.complete!
          end

          it_behaves_like 'offboarding window'
        end


        context 'task is unstarted' do
          before do
            offboard_task.state.should == 'unstarted'
          end

          it 'does not create an offboard task' do
            o = OffboardMemberTask.create_if_only_within_offboarding_window(member)
            o.should be_nil
          end
        end

        context 'task is started' do
          before do
            offboard_task.start!
          end

          it 'does not create an offboard task' do
            o = OffboardMemberTask.create_if_only_within_offboarding_window(member)
            o.should be_nil
          end
        end

        context 'task is claimed' do
          before do
            offboard_task.claim!
          end

          it 'does not create an offboard task' do
            o = OffboardMemberTask.create_if_only_within_offboarding_window(member)
            o.should be_nil
          end
        end
      end
    end

    context 'an offboard task does not exist within the offboarding window' do
      before do
        OffboardMemberTask.destroy_all
        OffboardMemberTask.all.count.should == 0
      end

      it 'creates an offboard task' do
        o = OffboardMemberTask.create_if_only_within_offboarding_window(member)
        o.should be_present
        o.should be_valid
      end
    end
  end
end
