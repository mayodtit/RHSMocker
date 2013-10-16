describe Api::V1::OfferingsController do
  let(:user) { build_stubbed(:user) }
  let(:offering) { build_stubbed(:offering) }

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    before(:each) do
      Offering.stub(:all => [offering])
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', :user => :authenticate! do
      it_behaves_like 'success'

      it 'returns an array of offerings' do
        do_request
        json = JSON.parse(response.body)
        json['offerings'].to_json.should == [offering].as_json.to_json
      end
    end
  end
end
