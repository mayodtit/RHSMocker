require 'spec_helper'

describe NurselineRecordsController do
  let(:api_user) { create(:api_user) }
  let(:auth_header) { ActionController::HttpAuthentication::Token.encode_credentials(api_user.auth_token) }

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

    context 'authenticated' do
      before(:each) do
        request.env['HTTP_AUTHORIZATION'] = auth_header
      end

      context 'authenticated with a body' do
        def do_request
          post :create, {:body => 'test'}
        end

        it_behaves_like 'success'
      end

      context 'with no body' do
        def do_request
          post :create, nil
        end

        it_behaves_like 'failure'
      end
    end
  end
end
