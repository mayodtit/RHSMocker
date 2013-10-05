require 'spec_helper'

describe UserContentLike do
  describe 'validations' do
    it 'should only allow a unique user_id + content_id pair' do
      create(:user_content_like, user_id: 1, content_id: 1, action: 1)
      create(:user_content_like, user_id: 1, content_id: 2, action: 1)
      create(:user_content_like, user_id: 2, content_id: 1, action: 1)

      expect { create(:user_content_like, user_id: 1, content_id: 1, action: 1) }.to raise_error
      expect { create(:user_content_like, user_id: 2, content_id: 1, action: 1) }.to raise_error

      # user should not be able to both like and unlike a content object
      expect { create(:user_content_like, user_id: 1, content_id: 1, action: -1) }.to raise_error
      expect { create(:user_content_like, user_id: 2, content_id: 1, action: -1) }.to raise_error
    end

    it 'should only create if user_id, content_id, and action are present' do
      create(:user_content_like, user_id: 1, content_id: 1, action: 1)

      expect { create(:user_content_like) }.to raise_error
      expect { create(:user_content_like, user_id: 2) }.to raise_error
      expect { create(:user_content_like, content_id: 2) }.to raise_error
      expect { create(:user_content_like, action: 2) }.to raise_error
      expect { create(:user_content_like, user_id: 2, content_id: 2) }.to raise_error
      expect { create(:user_content_like, user_id: 2, action: 2) }.to raise_error
      expect { create(:user_content_like, content_id: 2, action: 2) }.to raise_error
    end

    it 'should only allow 1 or -1 for action' do
      create(:user_content_like, user_id: 1, content_id: 1, action: 1)
      create(:user_content_like, user_id: 2, content_id: 2, action: -1)
      expect { create(:user_content_like, user_id: 3, content_id: 3, action: 2) }.to raise_error
    end
  end
end
