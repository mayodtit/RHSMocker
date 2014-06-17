require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Height' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:user_id) { user.id }
  let(:auth_token) { user.auth_token }

  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  context 'existing record' do
    let!(:height) { create(:height, user: user) }

    get '/api/v1/users/:user_id/heights' do
      example_request '[GET] Get all Heights' do
        explanation 'Returns an array of Heights'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:heights].to_json).to eq([height].serializer.as_json.to_json)
      end
    end

    get '/api/v1/users/:user_id/heights/:id' do
      let(:id) { height.id }

      example_request '[GET] Get Height' do
        explanation 'Returns the Height'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:height].to_json).to eq(height.serializer.as_json.to_json)
      end
    end

    put '/api/v1/users/:user_id/heights/:id' do
      parameter :amount, 'Amount in centimeters'
      parameter :taken_at, 'Timestamp of when the height reading was taken'
      scope_parameters :height, [:amount, :taken_at]
      required_parameters :amount, :taken_at

      let(:amount) { 182.88 }
      let(:id) { height.id }
      let(:raw_post) { params.to_json }

      example_request '[PUT] Update Height' do
        explanation 'Update the Height'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:height][:amount]).to eq(amount.to_s)
      end
    end

    delete '/api/v1/users/:user_id/heights/:id' do
      let(:id) { height.id }
      let(:raw_post) { params.to_json }

      example_request '[DELETE] Destroy Height' do
        explanation 'Destroy an Height'
        expect(status).to eq(200)
      end
    end
  end

  post '/api/v1/users/:user_id/heights' do
    parameter :amount, 'Amount in centimeters'
    parameter :taken_at, 'Timestamp of when the height reading was taken'
    scope_parameters :height, [:amount, :taken_at]
    required_parameters :amount, :taken_at

    let(:amount) { 182.88 }
    let(:taken_at) { Time.now }
    let(:raw_post) { params.to_json }

    example_request '[POST] Create Height' do
      explanation 'Create the Height'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:height][:amount]).to eq(amount.to_s)
    end
  end
end
