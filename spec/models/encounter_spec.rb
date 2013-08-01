require 'spec_helper'

describe Encounter do
  it_has_a 'valid factory'

  describe 'validations' do
    before(:each) do
      Encounter.any_instance.stub(:set_defaults)
    end

    it_validates 'presence of', :status
    it_validates 'inclusion of', :checked
    it_validates 'length of', :users
  end
end
