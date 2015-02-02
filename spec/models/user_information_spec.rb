require 'spec_helper'

describe UserInformation do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'uniqueness of', :user_id

  let!(:member) { create :member }

  before do
    UserChange.destroy_all
  end

  describe '#track_change' do
    context 'on create' do
      def create_info
        UserInformation.create( user_id: member.id, notes: 'test' )
      end

      it 'should log the created user information in the user change log' do
        create_info
        expect( UserChange.all.first.data['notes'].last).to eq('test')
      end
    end

    context 'on update' do
      let!(:user_information) { create :user_information, user: member }

      def update_info
        UserChange.destroy_all
        user_information.update_attributes( notes: 'test')
      end

      it 'should log the updated user information in the user change log' do
        update_info
        expect( UserChange.all.first.data['notes']).to eq([nil,'test'])
      end
    end
  end

  describe '#track_destroy' do
    context 'on destroy' do
      let!(:user_information) { create :user_information, user: member, notes: 'test' }

      def destroy_info
        UserChange.destroy_all
        UserInformation.destroy(user_information)
      end

      it 'should log the destroyed user information in the user change log' do
        destroy_info
        expect( UserChange.all.first.data[:user_information]['id']).to eq(user_information.id)
      end
    end
  end
end
