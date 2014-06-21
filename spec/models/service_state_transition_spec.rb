require 'spec_helper'

describe ServiceStateTransition do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :service
    it_validates 'presence of', :created_at
    it_validates 'presence of', :actor
  end
end
