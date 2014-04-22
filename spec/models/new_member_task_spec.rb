require 'spec_helper'

describe NewMemberTask do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :member_id
    it_validates 'foreign key of', :member
  end
end
