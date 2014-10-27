require 'spec_helper'

describe Enrollment do
  it_has_a 'valid factory'

  describe 'presence validations' do
    before do
      described_class.any_instance.stub(:set_token)
    end
    it_validates 'presence of', :token
  end

  it_validates 'uniqueness of', :token
end
