require 'spec_helper'

describe UserImage do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'allows blank uniqueness of', :client_guid

  describe 'callbacks' do
    describe '#set_foreign_references' do
      let!(:message) { create(:message, user_image_client_guid: 'GUID') }

      it 'sets foreign keys of models with matching client_guids' do
        image = build(:user_image, user_id: message.user_id,
                                   client_guid: message.user_image_client_guid)
        expect(message.user_image).to be_nil
        image.save!
        expect(message.reload.user_image).to eq(image)
      end
    end
  end
end
