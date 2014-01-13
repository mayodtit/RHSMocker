require 'spec_helper'

describe 'Agreements' do
  let!(:agreement) { create(:agreement, :active) }

  describe 'GET /api/v1/agreements' do
    def do_request
      get '/api/v1/agreements'
    end

    it 'indexes all active Agreements' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      expect(body[:agreements].to_json).to eq([agreement].as_json.to_json)
    end
  end

  describe 'GET /api/v1/agreements/:id' do
    def do_request
      get "/api/v1/agreements/#{agreement.id}"
    end

    it 'shows the Agreement' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      expect(body[:agreement].to_json).to eq(agreement.as_json.to_json)
    end
  end

  describe 'GET /api/v1/agreements/current' do
    def do_request
      get '/api/v1/agreements/current'
    end

    it 'shows the current active Agreement' do
      do_request
      expect(response).to be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      expect(body[:agreement].to_json).to eq(agreement.as_json.to_json)
    end
  end
end
