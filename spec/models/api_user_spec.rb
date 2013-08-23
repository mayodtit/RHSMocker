require 'spec_helper'

describe ApiUser do
  it_has_a 'valid factory'
  it_validates 'presence of', :name

  describe 'callbacks' do
    it 'generates auth_token on create' do
      create(:api_user, :auth_token => nil).auth_token.should_not be_nil
    end

    it 'removes auth_token on destroy' do
      api_user = create(:api_user)
      api_user.auth_token.should_not be_nil
      api_user.destroy
      api_user.reload.auth_token.should be_nil
    end
  end
end
