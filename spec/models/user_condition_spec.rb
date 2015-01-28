require 'spec_helper'

describe UserCondition do
  it_has_a 'valid factory'

  it_validates 'presence of', :user
  it_validates 'presence of', :condition

  describe 'diagnosed' do
    let(:diagnosed_user_condition) { build_stubbed(:user_condition, :diagnosed) }

    describe 'factory trait' do
      it 'creates valid objects' do
        diagnosed_user_condition.should be_valid
      end

      it 'creates diagnosed objects' do
        diagnosed_user_condition.diagnosed.should be_true
      end
    end
  end

  describe '#user_treatment_ids=' do
    let(:user) { create(:member) }
    let(:user_condition) { create(:user_condition, :user => user) }
    let(:user_treatment) { create(:user_treatment, :user => user) }

    it 'links the user_treatment to the user_condition' do
      user_condition.user_treatments.should_not include(user_treatment)
      user_condition.update_attributes(user_treatment_ids: [user_treatment.id]).should be_true
      user_condition.reload.user_treatments.should include(user_treatment)
    end

    it 'deletes user_treatments removed from the list' do
      user_condition.user_treatments << user_treatment
      user_condition.user_treatments.should include(user_treatment)
      user_condition.update_attributes(user_treatment_ids: []).should be_true
      user_condition.reload.user_treatments.should_not include(user_treatment)
    end
  end

  describe '#track_create' do
    let!(:member) { create :member }
    let(:user_condition) { build :user_condition, user: member }

    before do
      # Prevent changes from being tracked on other models, so we can isolate this one.
      Member.any_instance.stub(:track_update)
      UserChange.destroy_all
    end

    it 'it tracks a change after a condition is added to a user' do
      user_condition.save!
      UserChange.count.should == 1
      u = UserChange.last
      u.user.should == member
      u.actor.should == Member.robot
      u.action.should == 'add'
      u.data.should == {conditions: [user_condition.condition.name]}
    end

    context 'actor_id is defined' do
      let(:pha) { build_stubbed :pha }

      before do
        user_condition.actor_id = pha.id
      end

      it 'uses the defined actor id' do
        UserChange.should_receive(:create!).with hash_including(actor_id: pha.id)
        user_condition.track_create
      end
    end
  end

  describe '#track_destroy' do
    let!(:member) { create :member }
    let!(:condition) { create :condition }
    let!(:user_condition) { create :user_condition, condition: condition, user: member }

    before do
      # Prevent changes from being tracked on other models, so we can isolate this one.
      Member.any_instance.stub(:track_update)
      UserChange.destroy_all
    end

    it 'it tracks a change after a condition is added to a user' do
      user_condition.destroy
      UserChange.count.should == 1
      u = UserChange.last
      u.user.should == member
      u.actor.should == Member.robot
      u.action.should == 'destroy'
      u.data.should == {conditions: [condition.name]}
    end

    context 'actor_id is defined' do
      let(:pha) { build_stubbed :pha }

      before do
        user_condition.actor_id = pha.id
      end

      it 'uses the defined actor id' do
        UserChange.should_receive(:create!).with hash_including(actor_id: pha.id)
        user_condition.track_destroy
      end
    end
  end
end
