require 'spec_helper'

describe UserAllergy do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :allergy
  it_validates 'uniqueness of', :allergy_id, :user_id

  describe '#track_create' do
    let!(:member) { create :member }
    let(:user_allergy) { build :user_allergy, user: member }

    before do
      # Prevent changes from being tracked on other models, so we can isolate this one.
      Member.any_instance.stub(:track_update)
      UserChange.destroy_all
    end

    it 'it tracks a change after a allergy is added to a user' do
      user_allergy.save!
      UserChange.count.should == 1
      u = UserChange.last
      u.user.should == member
      u.actor.should == Member.robot
      u.action.should == 'add'
      u.data.should == {allergies: [user_allergy.allergy.name]}
    end

    context 'actor_id is defined' do
      let(:pha) { build_stubbed :pha }

      before do
        user_allergy.actor_id = pha.id
      end

      it 'uses the defined actor id' do
        UserChange.should_receive(:create!).with hash_including(actor_id: pha.id)
        user_allergy.track_create
      end
    end
  end

  describe '#track_destroy' do
    let!(:member) { create :member }
    let!(:allergy) { create :allergy }
    let!(:user_allergy) { create :user_allergy, allergy: allergy, user: member }

    before do
      # Prevent changes from being tracked on other models, so we can isolate this one.
      Member.any_instance.stub(:track_update)
      UserChange.destroy_all
    end

    it 'it tracks a change after a allergy is added to a user' do
      user_allergy.destroy
      UserChange.count.should == 1
      u = UserChange.last
      u.user.should == member
      u.actor.should == Member.robot
      u.action.should == 'destroy'
      u.data.should == {allergies: [allergy.name]}
    end

    context 'actor_id is defined' do
      let(:pha) { build_stubbed :pha }

      before do
        user_allergy.actor_id = pha.id
      end

      it 'uses the defined actor id' do
        UserChange.should_receive(:create!).with hash_including(actor_id: pha.id)
        user_allergy.track_destroy
      end
    end
  end
end
