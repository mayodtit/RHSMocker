require 'spec_helper'

describe NurselineRecordsController do
  let(:api_user) { create(:api_user) }
  let(:auth_header) { {'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(api_user.auth_token)} }

  describe 'POST create' do
    context 'without authentication' do
      def do_request
        post :create
      end

      it_behaves_like 'failure'

      it 'returns 401' do
        do_request
        response.code.should == '401'
      end
    end

    context 'authenticated with a body' do
      def do_request
        post :create, {:body => 'test'}, auth_header
      end

      it_behaves_like 'success'
    end

    context 'with no body' do
      def do_request
        post :create, nil, auth_header
      end

      it_behaves_like 'failure'
    end
  end
end
