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
      JSON.parse(response.body).should have_key('use_invite_flow')
    end

    it_behaves_like 'success'

    context 'with an auth_token' do
      def do_request
        get :index, :auth_token => 'BAADBEEFDEADBEEF'
      end

      it_behaves_like 'action requiring authentication'

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
    end
  end
end
