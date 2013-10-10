require 'spec_helper'

describe UserContentLike do
  describe 'validations' do
    it 'should only allow a unique user_id + content_id pair' do
      create(:user_content_like, user_id: 1, content_id: 1, action: 'like')
      create(:user_content_like, user_id: 1, content_id: 2, action: 'like')
      create(:user_content_like, user_id: 2, content_id: 1, action: 'like')

      #create(:user_content_like, user_id: 1, content_id: 1, action: 'like')
      expect { create(:user_content_like, user_id: 1, content_id: 1, action: 'like') }.to raise_error(ActiveRecord::RecordInvalid)
      expect { create(:user_content_like, user_id: 2, content_id: 1, action: 'like') }.to raise_error(ActiveRecord::RecordInvalid)

      # user should not be able to both like and unlike a content object
      expect { create(:user_content_like, user_id: 1, content_id: 1, action: 'dislike') }.to raise_error(ActiveRecord::RecordInvalid)
      expect { create(:user_content_like, user_id: 2, content_id: 1, action: 'dislike') }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should only create if user_id, content_id, and action are present' do
      create(:user_content_like, user_id: 1, content_id: 1, action: 'like')

      expect { create(:user_content_like) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { create(:user_content_like, user_id: 2) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { create(:user_content_like, content_id: 2) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { create(:user_content_like, action: 'like') }.to raise_error(ActiveRecord::RecordInvalid)
      expect { create(:user_content_like, user_id: 2, content_id: 2) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { create(:user_content_like, user_id: 2, action: 'like') }.to raise_error(ActiveRecord::RecordInvalid)
      expect { create(:user_content_like, content_id: 2, action: 'like') }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should only allow 1 or -1 for action' do
      create(:user_content_like, user_id: 1, content_id: 1, action: 'like')
      create(:user_content_like, user_id: 2, content_id: 2, action: 'dislike')
      expect { create(:user_content_like, user_id: 3, content_id: 3, action: 'foobar') }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
