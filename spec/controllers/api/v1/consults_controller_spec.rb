require 'spec_helper'

describe Api::V1::ConsultsController do
  let(:consult) { build_stubbed(:consult) }
  let(:user) { consult.initiator }
  let(:ability) { Object.new.extend(CanCan::Ability) }

  before do
    controller.stub(current_ability: ability)
  end

  describe 'GET index' do
    def do_request
      get :index
    end

    before do
      user.stub_chain(:initiated_consults, :where).and_return([consult])
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it "returns an array of Consults" do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:consults].to_json).to eq([consult].serializer.as_json.to_json)
      end
    end
  end

  describe 'GET current' do
    def do_request
      get :current
    end

    before do
      user.stub(master_consult: consult)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the consult' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:consult].to_json).to eq(consult.serializer.as_json.to_json)
      end
    end
  end

  describe 'GET show' do
    def do_request
      get :show
    end

    before do
      Consult.stub(find: consult)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it_behaves_like 'success'

      it 'returns the consult' do
        do_request
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:consult].to_json).to eq(consult.serializer.as_json.to_json)
      end
    end
  end

  describe 'POST create' do
    def do_request
      post :create, consult: attributes_for(:consult)
    end

    before do
      Consult.stub(create: consult,
                   find: consult)
      consult.stub(:reload)
    end

    it_behaves_like 'action requiring authentication and authorization'

    context 'authenticated and authorized', user: :authenticate_and_authorize! do
      it 'attempts to create the record' do
        Consult.should_receive(:create).once
        do_request
      end

      context 'save succeeds' do
        it_behaves_like 'success'

        it 'returns the consult' do
          do_request
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:consult].to_json).to eq(consult.serializer.as_json.to_json)
        end
      end

      context 'save fails' do
        before do
          consult.errors.add(:base, :invalid)
        end

        it_behaves_like 'failure'
      end
    end
  end
end
