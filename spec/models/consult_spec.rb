require 'spec_helper'

describe Consult do
  it_has_a 'valid factory'

  describe 'validations' do
    before(:each) do
      Consult.any_instance.stub(:set_defaults)
    end

    it_validates 'presence of', :title
    it_validates 'presence of', :initiator
    it_validates 'presence of', :subject
    it_validates 'presence of', :status
    it_validates 'presence of', :priority
    it_validates 'scoped uniqueness of', :subject_id, :initiator_id
    it_validates 'inclusion of', :checked
    it_validates 'length of', :users
  end
end
