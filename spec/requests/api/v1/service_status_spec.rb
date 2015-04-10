require 'spec_helper'

describe 'ServiceStatus' do
  let(:user) { create(:member) }
  let(:pha_role) { create(:role) }

  before do
    Role.safe_stub(:pha).and_return(pha_role)
  end

  describe 'GET /api/v1/service_status' do
    def do_request
      get '/api/v1/service_status'
    end

    context 'on_call?' do
      before do
        pha_role.safe_stub(:on_call?).and_return(true)
      end

      it 'returns the online hash' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:service_status][:status]).to eq('online')
        expect(body[:service_status][:message]).to be_nil
      end
    end

    context 'not on_call?' do
      before do
        pha_role.safe_stub(:on_call?).and_return(false)
      end

      it 'returns the offline hash' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:service_status][:status]).to eq('offline')
        expect(body[:service_status][:message]).to_not be_nil
      end
    end
  end
end
