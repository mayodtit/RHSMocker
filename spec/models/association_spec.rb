require 'spec_helper'

describe Association do
  it_has_a 'valid factory'
  describe 'validations' do
    it_validates 'presence of', :user
    it_validates 'presence of', :associate
    it 'requires the user is not the associate' do
      user = build_stubbed(:user)
      build_stubbed(:association, user: user, associate: user).should_not be_valid
    end
    it_validates 'uniqueness of', :associate_id, :user_id, :association_type_id
  end
end
