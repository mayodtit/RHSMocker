require 'spec_helper'

describe Session do
  it_has_a 'valid factory'

  describe 'validations' do
    before do
      described_class.any_instance.stub(:set_auth_token)
    end

    it_validates 'presence of', :member
    it_validates 'presence of', :auth_token
  end
end
