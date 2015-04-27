require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Weight' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:user_id) { user.id }
  let(:auth_token) { session.auth_token }

  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  context 'existing record' do
    let!(:weight) { create(:weight, user: user) }

    get '/api/v1/users/:user_id/weights' do
      example_request '[GET] Get all Weights' do
        explanation 'Returns an array of Weights'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:weights].to_json).to eq([weight].serializer.as_json.to_json)
      end
    end

    get '/api/v1/users/:user_id/weights/:id' do
      let(:id) { weight.id }

      example_request '[GET] Get Weight' do
        explanation 'Returns the Weight'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:weight].to_json).to eq(weight.serializer.as_json.to_json)
      end
    end

    put '/api/v1/users/:user_id/weights/:id' do
      parameter :amount, 'Amount in kilograms'
      parameter :bmi, 'BMI for entry'
      parameter :taken_at, 'Timestamp of when the weight reading was taken'
      scope_parameters :weight, %i(amount bmi taken_at)
      required_parameters :amount, :taken_at

      let(:amount) { 182.88 }
      let(:id) { weight.id }
      let(:raw_post) { params.to_json }

      example_request '[PUT] Update Weight' do
        explanation 'Update the Weight'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:weight][:amount]).to eq(amount.to_s)
      end
    end

    delete '/api/v1/users/:user_id/weights/:id' do
      let(:id) { weight.id }
      let(:raw_post) { params.to_json }

      example_request '[DELETE] Destroy Weight' do
        explanation 'Destroy an Weight'
        expect(status).to eq(200)
      end
    end
  end

  post '/api/v1/users/:user_id/weights' do
    parameter :amount, 'Amount in kilograms'
    parameter :bmi, 'BMI for entry'
    parameter :taken_at, 'Timestamp of when the weight reading was taken'
    scope_parameters :weight, %i(amount bmi taken_at)
    required_parameters :amount, :taken_at

    let(:amount) { 182.88 }
    let(:taken_at) { Time.now }
    let(:raw_post) { params.to_json }

    example_request '[POST] Create Weight' do
      explanation 'Create the Weight'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:weight][:amount]).to eq(amount.to_s)
      body[:weight][:creator_id].should == user.id
      w = Weight.find body[:weight][:id]
      expect(w.creator).to eq(user)
    end
  end
end
