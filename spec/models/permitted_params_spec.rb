require 'spec_helper'

describe PermittedParams do
  describe '#user' do
    let(:params_hash) {
                        {
                          first_name: 'Kyle',
                          junk: 'junk',
                          email: 'kyle@test.com',
                          password: 'password',
                          waitlist_entry: 'test',
                          user_information_attributes: {id: 1},
                          address_attributes: {id: 2},
                          insurance_policy_attributes: {id: 3},
                          provider_attributes: {id: 4}
                        }
                      }
    let(:params) { ActionController::Parameters.new(user: params_hash) }
    let(:permitted_params) { described_class.new(params, build_stubbed(:member)) }

    it 'returns only the permitted parameters' do
      expect(permitted_params.user).to have_key(:first_name)
      expect(permitted_params.user).to_not have_key(:junk)
      expect(permitted_params.user).to_not have_key(:user_information_attributes)
      expect(permitted_params.user).to_not have_key(:address_attributes)
      expect(permitted_params.user).to_not have_key(:insurance_policy_attributes)
      expect(permitted_params.user).to_not have_key(:provider_attributes)
    end

    it 'always returns client_data' do
      expect(permitted_params.user).to have_key(:client_data)
    end

    context 'current_user is false (the Sorcery nil)' do
      let(:permitted_params) { described_class.new(params, false) }

      it 'includes new user attributes' do
        expect(permitted_params.user).to have_key(:email)
        expect(permitted_params.user).to have_key(:password)
        expect(permitted_params.user).to have_key(:waitlist_entry)
      end
    end

    context 'with a current_user' do
      let(:permitted_params) { described_class.new(params, build_stubbed(:member)) }

      it 'does not include restricted attributes' do
        expect(permitted_params.user).to have_key(:email)
        expect(permitted_params.user).to_not have_key(:password)
        expect(permitted_params.user).to_not have_key(:waitlist_entry)
      end
    end

    context 'with a current user that is the subject' do
      let(:current_user) { build_stubbed(:member) }
      let(:permitted_params) { described_class.new(params, current_user, current_user) }

      it 'does not include restricted attributes' do
        expect(permitted_params.user).to_not have_key(:email)
        expect(permitted_params.user).to_not have_key(:password)
        expect(permitted_params.user).to_not have_key(:waitlist_entry)
      end
    end

    context 'as an admin' do
      let(:permitted_params) { described_class.new(params, create(:admin)) }

      it 'does not include restricted attributes' do
        expect(permitted_params.user).to have_key(:user_information_attributes)
        expect(permitted_params.user).to have_key(:address_attributes)
        expect(permitted_params.user).to have_key(:insurance_policy_attributes)
        expect(permitted_params.user).to have_key(:provider_attributes)
      end
    end
  end
end
