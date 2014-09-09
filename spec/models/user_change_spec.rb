require 'spec_helper'

describe UserChange do
  it_has_a 'valid factory'

  describe '#validations' do
    it_validates 'presence of', :user
    it_validates 'presence of', :actor
    it_validates 'presence of', :data
    it_validates 'inclusion of', :action, ['add', 'update', 'destroy']
  end
end
