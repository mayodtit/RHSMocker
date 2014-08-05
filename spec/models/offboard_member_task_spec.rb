require 'spec_helper'

describe OffboardMemberTask do
  before do
    @service_type = ServiceType.find_or_create_by_name! name: 'member offboarding', bucket: 'engagement'
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
      task.due_at = 1.business_day.before(task.member.free_trial_ends_at.pacific)
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

  describe '#create_if_only_for_current_free_trial' do
    let!(:pha) { create :pha }
    let!(:member) { create :member, :trial, free_trial_ends_at: Time.now, pha: pha }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    context 'member does not have free trial ends at' do
      let!(:member) { create :member, :premium, pha: pha }

      it 'does not create an offboard task' do
        o = OffboardMemberTask.create_if_only_for_current_free_trial(member)
        o.should be_nil
      end
    end

    context 'member has free trial ends at' do
      context 'member has offboarding member task' do
        let!(:offboard_task) { create :offboard_member_task, member: member, member_free_trial_ends_at: Time.now }

        context 'for the current free trial end date' do
          it 'does not create an offboard task' do
            o = OffboardMemberTask.create_if_only_for_current_free_trial(member)
            o.should be_nil
          end
        end

        context 'for a previous free trial end date' do
          before do
            offboard_task.member_free_trial_ends_at = member.free_trial_ends_at - 2.hours
            offboard_task.save!
          end

          it 'creates an offboard task' do
            o = OffboardMemberTask.create_if_only_for_current_free_trial(member)
            o.should be_present
            o.should be_valid
          end
        end
      end

      context 'member does not have offboarding member task' do
        before do
          OffboardMemberTask.where(member_id: member.id).count.should == 0
        end

        it 'creates an offboard task' do
          o = OffboardMemberTask.create_if_only_for_current_free_trial(member)
          o.should be_present
          o.should be_valid
        end
      end
    end

    context 'an offboard task exists for another member' do
      let!(:other_member) { create :member, free_trial_ends_at: Time.now }
      let!(:offboard_task) { create :offboard_member_task, member: other_member, member_free_trial_ends_at: Time.now }

      it 'creates an offboard task' do
        o = OffboardMemberTask.create_if_only_for_current_free_trial(member)
        o.should be_present
        o.should be_valid
      end
    end
  end
end
