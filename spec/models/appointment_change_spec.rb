require 'spec_helper'

describe AppointmentChange do
  it_has_a 'valid factory'

  describe '#validations' do
    it_validates 'presence of', :appointment
    it_validates 'presence of', :actor
  end
end