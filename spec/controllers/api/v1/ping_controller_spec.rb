require 'spec_helper'

describe Api::V1::PingController do
  let(:user) { build_stubbed(:member) }
  let(:metadata1) { build_stubbed(:metadata, mkey: 'use_invite_flow') }
  let(:metadata2) { build_stubbed(:metadata) }

  before(:each) do
    Metadata.stub(:all => [metadata1, metadata2])
    Metadata.stub(:use_invite_flow? => false)
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'success'

    it 'responds with use_invite_flow' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body).to have_key(:use_invite_flow)
    end

    describe 'version validity' do
      it 'defaults to valid' do
        do_request
        JSON.parse(response.body).should have_key('use_invite_flow')
      end

      context 'with valid version' do
        def do_request
          get :index, version: '1.0.1'
        end

        it 'indicates valid to the client' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:valid]).to eq(true)
        end
      end

      context 'with invalid version' do
        def do_request
          get :index, version: '0.0.99'
        end

        it 'indicates invalid and app_store_url to the client' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:valid]).to eq(false)
          expect(body).to have_key(:app_store_url)
        end
      end
    end

    context 'with an auth_token' do
      def do_request
        get :index, :auth_token => 'BAADBEEFDEADBEEF'
      end

      context 'authenticated', :user => :authenticate! do
        it_behaves_like 'success'

        it 'renders application metadata' do
          do_request
          json = JSON.parse(response.body)
          json.should have_key('use_invite_flow')
          metadata = json['metadata']
          metadata[metadata2.mkey].should == metadata2.mvalue
          metadata.should_not have_key('use_invite_flow')
        end
      end

      context 'invalid token' do
        it_behaves_like 'success'

        it 'responds with use_invite_flow' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body).to have_key(:use_invite_flow)
        end
      end
    end
  end
end
