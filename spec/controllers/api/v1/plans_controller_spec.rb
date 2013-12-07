describe Api::V1::PlansController do
  let(:user) { build_stubbed(:user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:plan) { build_stubbed(:plan) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    before(:each) do
      Plan.stub(:all => [plan])
    end

    xit{ it_behaves_like 'action requiring authentication and authorization' }

    context 'authenticated and authorized', :user => :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns an array of plans' do
        do_request
        json = JSON.parse(response.body)
        json['plans'].to_json.should == [plan].serializer.as_json.to_json
      end
    end
  end
end
