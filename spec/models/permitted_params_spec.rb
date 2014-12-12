require 'spec_helper'

describe PermittedParams do
  describe '#user' do
    let(:params_hash) {
                        {
                          first_name: 'Kyle',
                          junk: 'junk',
                          email: 'kyle@test.com',
                          password: 'password',
                          user_information_attributes: {id: 1},
                          addresses_attributes: {id: 2},
                          provider_attributes: {id: 3}
                        }
                      }
    let(:params) { ActionController::Parameters.new(user: params_hash) }
    let(:permitted_params) { described_class.new(params, build_stubbed(:member)) }

    it 'returns only the permitted parameters' do
      expect(permitted_params.user).to have_key(:first_name)
      expect(permitted_params.user).to have_key(:addresses_attributes)
      expect(permitted_params.user).to_not have_key(:junk)
      expect(permitted_params.user).to_not have_key(:user_information_attributes)
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
        expect(permitted_params.user).to_not have_key(:addresses_attributes)
      end
    end

    context 'with a current_user' do
      let(:permitted_params) { described_class.new(params, build_stubbed(:member)) }

      it 'does not include restricted attributes' do
        expect(permitted_params.user).to have_key(:email)
        expect(permitted_params.user).to have_key(:addresses_attributes)
        expect(permitted_params.user).to_not have_key(:password)
      end
    end

    context 'with a current user that is the subject' do
      let(:current_user) { build_stubbed(:member) }
      let(:permitted_params) { described_class.new(params, current_user, current_user) }

      it 'does not include restricted attributes' do
        expect(permitted_params.user).to_not have_key(:email)
        expect(permitted_params.user).to_not have_key(:password)
      end
    end
  end

  describe '#secure_user' do
    let(:params_hash) {
                        {
                          email: 'new_email@test.com',
                          password: 'new_password',
                          junk: 'junk'
                        }
                      }
    let(:params) { ActionController::Parameters.new(user: params_hash) }

    context 'without a user' do
      let(:permitted_params) { described_class.new(params, false) }

      it 'returns only the permitted attributes' do
        expect(permitted_params.secure_user).to have_key(:email)
        expect(permitted_params.secure_user).to have_key(:password)
        expect(permitted_params.secure_user).to_not have_key(:junk)
      end
    end

    context 'with a subject that is not the current_user' do
      let(:permitted_params) { described_class.new(params,
                                                   build_stubbed(:member),
                                                   build_stubbed(:member)) }

      it 'does not allow any parameters' do
        expect(permitted_params.secure_user).to be_empty
      end
    end

    context 'when the current_user is the subject' do
      let(:current_user) { build_stubbed(:member) }
      let(:permitted_params) { described_class.new(params,
                                                   current_user,
                                                   current_user) }

      it 'returns only the permitted attributes' do
        expect(permitted_params.secure_user).to have_key(:email)
        expect(permitted_params.secure_user).to have_key(:password)
        expect(permitted_params.secure_user).to_not have_key(:junk)
      end
    end
  end
end
