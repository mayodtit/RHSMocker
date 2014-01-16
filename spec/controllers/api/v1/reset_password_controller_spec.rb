require 'spec_helper'

describe Api::V1::ResetPasswordController do
  describe 'POST create' do
    def do_request
      post :create
    end

    it 'raises ActiveRecord::RecordNotFound without email' do
      expect{ do_request }.to raise_error ActiveRecord::RecordNotFound
    end

    context 'with an email' do
      let(:user) { build_stubbed(:member) }

      before do
        Member.stub(find_by_email: user)
      end

      it_behaves_like 'success'
    end
  end

  describe 'GET show' do
    def do_request
      get :show
    end

    it 'raises ActiveRecord::RecordNotFound without token' do
      expect{ do_request }.to raise_error ActiveRecord::RecordNotFound
    end

    context 'with a token' do
      let(:user) { build_stubbed(:user) }

      before do
        Member.stub(find_by_reset_password_token!: user)
      end

      it_behaves_like 'success'
    end
  end

  describe 'PUT update' do
    def do_request
      put :update
    end

    it 'raises ActiveRecord::RecordNotFound without token' do
      expect{ do_request }.to raise_error ActiveRecord::RecordNotFound
    end

    context 'with a token' do
      let(:user) { build_stubbed(:user) }

      before do
        Member.stub(find_by_reset_password_token!: user)
      end

      context 'password change succeeds' do
        before do
          user.stub(change_password!: true)
        end

        it_behaves_like 'success'
      end

      context 'password change fails' do
        before do
          user.stub(change_password!: false)
          user.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
