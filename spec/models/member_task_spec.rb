require 'spec_helper'

describe MemberTask do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'foreign key of', :member
    it_validates 'foreign key of', :subject
  end
end
