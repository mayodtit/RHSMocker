require 'spec_helper'

describe TaskChange do
  it_has_a 'valid factory'

  describe '#validations' do
    it_validates 'presence of', :task
    it_validates 'presence of', :actor
  end


end
