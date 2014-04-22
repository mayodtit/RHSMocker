require 'spec_helper'

describe FollowUpTask do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :phone_call_id
    it_validates 'foreign key of', :phone_call
  end
end
