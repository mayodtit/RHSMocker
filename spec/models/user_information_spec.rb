require 'spec_helper'

describe UserInformation do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'uniqueness of', :user_id


  describe '#track_create' do
    let!(:member) { create :member }
    let(:user_information) { build :user_information, user: member }

    before do
      # Prevent changes from being tracked on other models, so we can isolate this one.
      Member.any_instance.stub(:track_update)
      UserChange.destroy_all
    end

    it 'it tracks a change after user information is added to a user' do
      user_information.save!
      UserInformation.count.should == 1
      u = UserChange.last
      u.user.should == member
      u.actor.should == Member.robot
      u.action.should == 'add'
      u.data.should == {informations: [user_information.user.first_name, user_information.user.last_name]}
    end

    context 'actor_id is defined' do
      let(:pha) { build_stubbed :pha }

      before do
        user_information.actor_id = pha.id
      end

      it 'uses the defined actor id' do
        UserChange.should_receive(:create!).with hash_including(actor_id: pha.id)
        user_information.track_create
      end
    end
  end

  describe '#track_destroy' do
    let!(:member) { create :member }
    let!(:user_information) { create :user_information, user: member }

    before do
      # Prevent changes from being tracked on other models, so we can isolate this one.
      Member.any_instance.stub(:track_update)
      UserChange.destroy_all
    end

    it 'tracks a change after user information is destroyed' do
      user_information.destroy
      UserChange.count.should == 1
      u = UserChange.last
      u.user.should == member
      u.actor.should == Member.robot
      u.action.should == 'destroy'
      u.data.should == {informations: [user_information.user.first_name,  user_information.user.last_name]}
    end

    context 'actor_id is defined' do
      let(:pha) { build_stubbed :pha }

      before do
        user_information.actor_id = pha.id
      end

      it 'uses the defined actor id' do
        UserChange.should_receive(:create!).with hash_including(actor_id: pha.id)
        user_information.track_destroy
      end
    end
  end
end
