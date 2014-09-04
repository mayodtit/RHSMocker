describe Api::V1::PlansController do
  let(:user) { build_stubbed(:user) }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'action requiring authentication'

    context 'authenticated', user: :authenticate! do
      it_behaves_like 'success'

      xit 'returns an array of plans' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:plans].to_json).to eq([plan].serializer.as_json.to_json)
      end
    end
  end
end
