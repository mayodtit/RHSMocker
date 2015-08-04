require 'spec_helper'

describe AppointmentTemplate do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :name
    it_validates 'presence of', :title
    it_validates 'presence of', :version
    it_validates 'presence of', :state
    it_validates 'uniqueness of', :state, :unique_id
    it_validates 'uniqueness of', :version, :unique_id
  end
end
