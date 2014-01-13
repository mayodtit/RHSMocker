describe Api::V1::AgreementsController do
  let(:user) { build_stubbed(:user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }
  let(:agreement) { build_stubbed(:agreement) }

  before(:each) do
    controller.stub(:current_ability => ability)
  end

  describe 'GET index' do
    def do_request
      get :index, auth_token: user.auth_token
    end

    before do
      Agreement.stub(active: [agreement])
    end

    it_behaves_like 'success'

    it 'returns an array of agreements' do
      do_request
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:agreements].to_json).to eq([agreement].serializer.as_json.to_json)
    end
  end
end
