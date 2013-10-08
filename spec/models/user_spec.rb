require 'spec_helper'

describe User do
  let(:user) { build(:user) }

  # TODO - this is a hack to eliminate false positives resulting from dirty database
  before(:each) do
    User.delete_all
  end

  it_has_a 'valid factory'

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
end
