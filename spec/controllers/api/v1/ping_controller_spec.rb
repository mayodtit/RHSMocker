require 'spec_helper'

describe Api::V1::PingController do
  let(:user) { build_stubbed(:member) }
  let(:metadata) { build_stubbed(:metadata) }

  before(:each) do
    Metadata.stub(:all => [metadata])
  end

  describe 'GET index' do
    def do_request
      get :index
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
          json = JSON.parse(response.body, :symbolize_names => true)
          json[:metadata][metadata.key.to_sym].should == metadata.value
        end
      end
    end
  end
end
