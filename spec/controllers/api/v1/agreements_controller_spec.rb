describe Api::V1::AgreementsController do
  let(:agreement) { build_stubbed(:agreement) }

  before do
    Agreement.stub(scoped: [agreement])
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'success'

    it 'returns an array of agreements' do
      do_request
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:agreements].to_json).to eq([agreement].as_json.to_json)
    end
  end

  describe 'GET show' do
    def do_request
      get :show
    end

    before do
      Agreement.stub_chain(:scoped, :find).and_return(agreement)
    end

    it_behaves_like 'success'

    it 'returns the agreement' do
      do_request
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:agreement].to_json).to eq(agreement.as_json.to_json)
    end
  end

  describe 'GET current' do
    def do_request
      get :current
    end

    before do
      Agreement.stub_chain(:scoped, :active).and_return(agreement)
    end

    it_behaves_like 'success'

    it 'returns the active agreement' do
      do_request
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:agreement].to_json).to eq(agreement.as_json.to_json)
    end
  end
end
