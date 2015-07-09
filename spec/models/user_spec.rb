require 'spec_helper'

describe User do
  let(:user) { build(:user) }

  # TODO - this is a hack to eliminate false positives resulting from dirty database
  before(:each) do
    User.delete_all
  end

  it_has_a 'valid factory'

  it 'validates member flag is nil' do
    user.stub(:unset_member_flag)
    expect(user).to be_valid
    user.member_flag = true
    expect(user).to_not be_valid
  end

  it 'validates email format' do
    expect(user).to be_valid
    user.email = 'junk'
    expect(user).to_not be_valid
  end

  describe '#set_default_hcp' do
    it 'sets default health care provider association' do
      u = create(:user)
      expect{u.set_default_hcp(14)}.to change{u.default_hcp_association_id}.from(nil).to(14)
    end
  end

  describe '#remove_default_hcp' do
    it 'removes default health care provier association' do
      u = create(:user, default_hcp_association_id: 14)
      expect{u.remove_default_hcp}.to change{u.default_hcp_association_id}.from(14).to(nil)
    end
  end

  describe '#credit_cards' do
    context 'user does not have a stripe account' do
      it 'should return an empty array' do
        build(:user).credit_cards.should eq([])
      end
    end

    context 'user has a stripe account' do
      context 'and has no credit cards on file' do
        xit 'should return an empty array' do

        end
      end

      context 'and has one credit card on file' do
        xit 'should return the credit card on file' do

        end
      end

      context 'and has more than one credit card on file' do
        xit 'should return the default credit card' do

        end
      end
    end
  end

  describe '#remove_all_credit_cards' do
    context 'user does not have a stripe id' do
      it 'should not call stripe' do
        Stripe::Customer.should_not_receive(:retrieve)
        build(:user).remove_all_credit_cards
      end
    end

    context 'user has a stripe id' do
      context 'user has no credit cards on file' do
        xit 'should not error out' do

        end
      end

      context 'user has one or more credit cards' do
        xit 'should remove all cards on file' do

        end
      end
    end
  end

  describe '#full_name' do
    let(:user) { build(:user) }


    context 'last_name is present' do
      before do
        user.stub(:last_name) { 'Smith' }
      end

      context 'first_name is present' do
        before do
          user.stub(:first_name) { 'John' }
        end

        it 'returns first + last name' do
          user.full_name.should == 'John Smith'
        end
      end

      context 'first_name is not present' do
        before do
          user.stub(:first_name) { '' }
        end

        context 'gender is male' do
          before do
            user.stub(:gender) { 'M' }
          end

          it 'returns Mr.' do
            user.full_name.should == 'Mr. Smith'
          end
        end

        context 'gender is female' do
          before do
            user.stub(:gender) { 'F' }
          end

          it 'returns Mr.' do
            user.full_name.should == 'Ms. Smith'
          end
        end

        context 'gender is not known' do
          before do
            user.stub(:gender) { nil }
          end

          it 'returns Mr./Ms.' do
            user.full_name.should == 'Mr./Ms. Smith'
          end
        end
      end
    end

    context 'last_name is not present' do
      before do
        user.stub(:last_name) { '' }
      end

      context 'first_name is present' do
        before do
          user.stub(:first_name) { 'John' }
        end

        it 'returns first_name' do
          user.full_name.should == user.first_name
        end
      end

      context 'first_name is not present' do
        before do
          user.stub(:first_name) { '' }
        end

        it 'returns email' do
          user.full_name.should == user.email
        end
      end
    end
  end

  describe '#salutation' do
    context 'user has no first name' do
      it "should return 'there'" do
        u = build(:user, first_name: nil)
        expect(u.salutation).to eq('there')
      end
    end

    context 'user has first name' do
      it "should return the user's first name" do
        u = build(:user, first_name: 'foo', email: 'foo@bar.com')
        expect(u.salutation).to eq('foo')
      end
    end
  end

  describe '#age' do
    let!(:no_birthday_user) { build_stubbed(:user, :birth_date => nil) }
    let!(:baby_user) { build_stubbed(:user, :birth_date => 11.months.ago) }
    let!(:yr_user) { build_stubbed(:user, :birth_date => 13.months.ago) }
    let!(:adult_user) { build_stubbed(:user, :birth_date => 360.months.ago) }
    #let(:user) { blood_pressure.user }

    it 'correctly handles from basic birthdate' do
      adult_user.age.should == 30
    end

    it 'correctly handles empty birthday in age' do
      no_birthday_user.age.should be_nil
    end

    it 'correctly handles less than 1 year' do
      baby_user.age.should == 0
    end

    it 'correctly handles just over a year' do
      yr_user.age.should == 1
    end

  end

  describe 'observers' do
    it 'should generate Google Analytics UUID for a new user' do
      user.save
      user.reload
      user.google_analytics_uuid.should_not be_nil
    end
  end

  describe '#avatar_url' do
    it 'should return nil for a user without an image' do
      build(:user).avatar_url.should be_nil
    end
  end

  describe 'content likes and dislikes' do

    # these can be broken into individual specs for isolated testing but the code below requires less setup,
    # resulting in faster test execution
    it 'should allow user to like and dislike content, and show content that the user has liked and disliked' do
      def match_content(content_object, content_id, action)
        content_object.content_id.should == content_id
        content_object.action.should == action
      end

      u1 = create(:user)
      c1 = create(:content)
      c2 = create(:content)
      c3 = create(:content)

      # base cases
      u1.content_likes.should == []
      u1.content_dislikes.should == []

      # like new content
      c = u1.like_content(c1.id)
      u1.like_content(c2.id)
      d = u1.dislike_content(c3.id)
      u1.content_likes.should == [c1, c2]
      u1.content_dislikes.should == [c3]
      match_content(c, c1.id, 'like')
      match_content(d, c3.id, 'dislike')

      # repeatedly liking or disliking content should not raise errors
      expect { u1.like_content(c1.id) }.to_not raise_error
      expect { u1.dislike_content(c3.id) }.to_not raise_error

      # transition between like and dislike
      d = u1.dislike_content(c1.id)
      u1.content_likes.should == [c2]
      u1.content_dislikes.should == [c1, c3]
      match_content(d, c1.id, 'dislike')

      # remove likes and dislikes for content
      r = u1.remove_content_like(c2.id)
      u1.remove_content_like(c3.id)
      u1.content_likes.should == []
      u1.content_dislikes.should == [c1]
      match_content(r, c2.id, 'like')

      # attemtping to remove content that isn't liked should not raise errors
      expect { u1.remove_content_like(c2.id) }.to_not raise_error
    end
  end

  describe '#member' do
    it 'returns nil if the user has no email' do
      expect(build_stubbed(:user, email: nil).member).to be_nil
    end

    context 'with an email' do
      let(:member) { create(:member) }
      let(:user) { build_stubbed(:user, email: member.email) }

      it 'finds a member with the matching email' do
        expect(user.member).to eq(member)
      end
    end
  end

  describe '#member_or_invite!' do
    it 'returns nil if the user has no email' do
      expect(build_stubbed(:user, email: nil).member).to be_nil
    end

    context 'with an email' do
      context 'with a member' do
        let(:member) { create(:member) }
        let(:user) { build_stubbed(:user, email: member.email) }

        it 'finds a member with the matching email' do
          expect(user.member).to eq(member)
        end
      end

      context 'without a member' do
        let!(:inviter) { create(:member) }
        let(:email) { 'kyle@test.getbetter.com' }
        let(:user) { build_stubbed(:user, email: email) }

        it 'creates a member' do
          expect{ user.member_or_invite!(inviter) }.to change(Member, :count).by(1)
        end

        it 'returns the new member' do
          expect(user.member_or_invite!(inviter)).to eq(Member.find_by_email!(email))
        end

        it 'creates an invite for the new member' do
          expect{ user.member_or_invite!(inviter) }.to change(Invitation, :count).by(1)
        end
      end
    end
  end

  describe 'database constraints' do
    it 'does not prevent duplicate emails' do
      u1 = create(:user)
      u2 = build(:user, email: u1.email)
      expect{ u2.save!(validate: false) }.to_not raise_error
      expect(u2).to be_persisted
    end
  end

  describe '#publish' do
    let(:user) { build(:user) }

    context 'is called after' do
      it 'create' do
        user.should_receive(:publish)
        user.save!
      end

      it 'update' do
        user.save!
        user.should_receive(:publish)
        user.save!
      end
    end

    context 'new record' do
      before do
        user.stub(:id_changed?) { true }
      end

      it 'does nothing' do
        PubSub.should_not_receive(:publish)
      end
    end

    context 'old record' do
      let(:user) { build_stubbed(:user) }

      before do
        user.stub(:id_changed?) { false }
        user.stub(:id) { 1 }
      end

      it 'publishes that a user was updated' do
        PubSub.should_receive(:publish).with(
          "/users/#{user.id}/update",
          {id: user.id}
        )
        user.publish
      end
    end
  end

  describe '#test?' do
    it 'returns false if email is nil' do
      build_stubbed(:user, email: nil).should_not be_test
    end

    it 'returns true if email is @getbetter.com' do
      build_stubbed(:user, email: 'abhik@getbetter.com').should be_test
    end

    it 'returns true if email is @example.com' do
      build_stubbed(:user, email: 'abhik@example.com').should be_test
    end

    it 'returns false if email ends with something else' do
      build_stubbed(:user, email: 'abhik@mayo.example.com').should_not be_test
      build_stubbed(:user, email: 'abhik@gmail.com').should_not be_test
    end
  end

  describe "phone numbers" do
    let(:user)  do
      u = create :user
      u.phone = "4153333333"
      u.work_phone_number = "4154444444"
      u.text_phone_number = "4155555555"
      u
    end

    context ".create" do
      it "creates a phone number" do
        expect(user.phone).to eq "4153333333"
      end
      it "creates a work phone number" do
        expect(user.work_phone_number).to eq "4154444444"
      end
      it "creates a text phone number" do
        expect(user.text_phone_number).to eq "4155555555"
      end
    end

    context ".update" do
      it "updates phone using setter" do
        user.phone = "4156666666"
        expect(user.phone).to eq "4156666666"
      end
      it "updates using update_attributes" do
        user.update_attributes(phone: "4157777777")
        expect(user.phone).to eq "4157777777"
      end
    end
  end

  describe '#track_update' do
    let!(:user) { create :user }

    before do
      UserChange.destroy_all
    end

    context 'nothing changed' do
      context 'because no changes were made' do
        it 'does nothing' do
          UserChange.should_not_receive(:create!)
          user.send(:track_update)
        end
      end

      context 'because only created_at and updated_at were changed' do
        it 'does nothing' do
          user.created_at = 4.days.ago
          user.updated_at = 3.days.ago
          user.changes.should_not be_empty
          UserChange.should_not_receive(:create!)
          user.send(:track_update)
        end
      end
    end

    context 'something changed' do
      it 'it tracks a change after a condition is added to a user' do
        old_last_name = user.last_name
        user.update_attributes!(gender: 'M', last_name: 'Poop')
        UserChange.count.should == 1
        u = UserChange.last
        u.user.should == user
        u.actor.should == Member.robot
        u.action.should == 'update'
        u.data.should == {"gender" => [nil, 'M'], "last_name" => [old_last_name, 'Poop']}
      end

      context 'actor_id is defined' do
        let(:pha) { build_stubbed :pha }

        before do
          user.actor_id = pha.id
          user.last_name = 'Poop'
        end

        it 'uses the defined actor id' do
          UserChange.should_receive(:create!).with hash_including(actor_id: pha.id)
          user.send(:track_update)
        end
      end
    end
  end
end
