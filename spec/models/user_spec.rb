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

  describe '#set_premium_flag' do
    it 'sets the is_premium boolean to true' do
      u = create(:user)
      expect{u.set_premium_flag}.to change{u.is_premium}.from(false).to(true)
    end
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

  describe 'phone numbers' do
    it_validates 'phone number format of', :phone, false, true
    it_validates 'phone number format of', :work_phone_number, false, true
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
end
