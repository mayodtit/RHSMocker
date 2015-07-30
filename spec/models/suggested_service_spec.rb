require 'spec_helper'

describe SuggestedService do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :unoffered
  it_has_a 'valid factory', :offered
  it_has_a 'valid factory', :accepted
  it_has_a 'valid factory', :rejected
  it_has_a 'valid factory', :expired
  it_validates 'presence of', :user
  it_validates 'presence of', :suggested_service_template
  it_validates 'inclusion of', :user_facing

  describe 'state machine' do
    describe 'states' do
      describe '#user_facing_is_false' do
        it 'validates for all states except offer' do
          %i(unoffered accepted rejected expired).each do |state|
            suggested_service = build(:suggested_service, state, user_facing: true)
            expect(suggested_service).to_not be_valid
            expect(suggested_service.errors[:user_facing]).to include('must be false')
          end
        end
      end
    end
  end
end
