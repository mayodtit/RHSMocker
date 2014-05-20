require 'spec_helper'

describe ServiceType do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :name
  end
end
