require 'spec_helper'

describe UserRequestTypeField do
  it_has_a 'valid factory'
  it_validates 'presence of', :user_request_type
  it_validates 'presence of', :name
  it_validates 'presence of', :type
  it_validates 'presence of', :ordinal

  describe 'callbacks' do
    describe 'set_ordinal' do
      let!(:old_field) { create(:user_request_type_field) }
      let(:new_field) { build(:user_request_type_field, user_request_type: old_field.user_request_type) }

      it 'sets the ordinal to one past the maximum' do
        expect(new_field.ordinal).to be_nil
        expect(new_field.save).to be_true
        expect(new_field.ordinal).to eq(old_field.ordinal + 1)
      end
    end
  end
end
