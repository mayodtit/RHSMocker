require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Address' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:user_id) { user.id }
  let(:auth_token) { session.auth_token }

  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  context 'existing record' do
    let!(:address) { create(:address, user: user) }

    get '/api/v1/users/:user_id/addresses' do
      example_request '[GET] Get all Addresses' do
        explanation 'Returns an array of Addresses'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:addresses].to_json).to eq([address].serializer.as_json.to_json)
      end
    end

    get '/api/v1/users/:user_id/addresses/:id' do
      let(:id) { address.id }

      example_request '[GET] Get Address' do
        explanation 'Returns the Address'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:address].to_json).to eq(address.serializer.as_json.to_json)
      end
    end

    put '/api/v1/users/:user_id/addresses/:id' do
      parameter :name, 'User-defined identifier for the address'
      parameter :line1, 'Address line 1'
      parameter :line2, 'Address line 2'
      parameter :city, 'Address city'
      parameter :state, 'Address state (2 letter abbreviation)'
      parameter :postal_code, 'Address postal code (5 digit)'
      scope_parameters :address, [:line1, :line2, :city, :state, :postal_code]

      let(:line1) { '123 Test St.' }
      let(:id) { address.id }
      let(:raw_post) { params.to_json }

      example_request '[PUT] Update Address' do
        explanation 'Update the Address'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:address][:line1]).to eq(line1)
      end
    end

    get '/api/v1/users/:user_id/addresses/office' do
      let!(:address) { create(:address, user: user, name: 'office') }

      example_request '[GET] Get Address with the name office' do
        explanation 'Returns the Address with the name office'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:address].to_json).to eq(address.serializer.as_json.to_json)
      end
    end

    post '/api/v1/users/:user_id/addresses' do
      let!(:address) { create(:address, user: user, name: 'office') }

      parameter :name, 'office'
      parameter :line1, 'Address line 1'
      parameter :line2, 'Address line 2'
      parameter :city, 'Address city'
      parameter :state, 'Address state (2 letter abbreviation)'
      parameter :postal_code, 'Address postal code (5 digit)'
      scope_parameters :address, [:line1, :line2, :city, :state, :postal_code]

      let(:line1) { '123 Test St.' }
      let(:raw_post) { params.to_json }

      example_request '[POST] Create Address with the name office' do
        explanation 'Create the Address with the name office'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:address][:line1]).to eq(line1)
      end
    end

    put '/api/v1/users/:user_id/addresses/office' do
      let!(:address) { create(:address, user: user, name: 'office') }

      parameter :name, 'office'
      parameter :line1, 'Address line 1'
      parameter :line2, 'Address line 2'
      parameter :city, 'Address city'
      parameter :state, 'Address state (2 letter abbreviation)'
      parameter :postal_code, 'Address postal code (5 digit)'
      scope_parameters :address, [:line1, :line2, :city, :state, :postal_code]

      let(:city) { 'Address city' }
      let(:id) { address.id }
      let(:raw_post) { params.to_json }

      example_request '[PUT] Update Address' do
        explanation 'Update Office Address'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:address][:city]).to eq(city)
      end
    end

    delete '/api/v1/users/:user_id/addresses/:id' do
      let(:id) { address.id }
      let(:raw_post) { params.to_json }

      example_request '[DELETE] Destroy Address' do
        explanation 'Destroy an Address'
        expect(status).to eq(200)
      end
    end
  end

  post '/api/v1/users/:user_id/addresses' do
    parameter :name, 'User-defined identifier for the address'
    parameter :line1, 'Address line 1'
    parameter :line2, 'Address line 2'
    parameter :city, 'Address city'
    parameter :state, 'Address state (2 letter abbreviation)'
    parameter :postal_code, 'Address postal code (5 digit)'
    scope_parameters :address, [:line1, :line2, :city, :state, :postal_code]

    let(:line1) { '123 Test St.' }
    let(:raw_post) { params.to_json }

    example_request '[POST] Create Address' do
      explanation 'Create the Address'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:address][:line1]).to eq(line1)
    end
  end
end
