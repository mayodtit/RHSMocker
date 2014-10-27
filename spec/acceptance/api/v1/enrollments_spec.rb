require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Enrollment' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  context 'existing record' do
    let!(:enrollment) { create(:enrollment) }

    get '/api/v1/enrollments/:id' do
      let(:id) { enrollment.token }

      example_request '[GET] Get Enrollment' do
        explanation 'Returns the Enrollment by token'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:enrollment].to_json).to eq(enrollment.serializer.as_json.to_json)
      end
    end

    put '/api/v1/enrollments/:id' do
      parameter :email, 'User email'
      parameter :first_name, 'User first name'
      parameter :last_name, 'User last name'
      parameter :birth_date, 'User birth date'
      parameter :advertiser_id, 'Device IDFA'
      parameter :time_zone, 'Device time zone'
      scope_parameters :enrollment, %i(email first_name last_name birth_date advertiser_id time_zone)

      let(:email) { 'kyle@getbetter.com' }
      let(:id) { enrollment.token }
      let(:raw_post) { params.to_json }

      example_request '[PUT] Update Enrollment' do
        explanation 'Update the Enrollment by token'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:enrollment][:email]).to eq(email)
      end
    end
  end

  post '/api/v1/enrollments' do
    parameter :email, 'User email'
    parameter :first_name, 'User first name'
    parameter :last_name, 'User last name'
    parameter :birth_date, 'User birth date'
    parameter :advertiser_id, 'Device IDFA'
    parameter :time_zone, 'Device time zone'
    scope_parameters :enrollment, %i(email first_name last_name birth_date advertiser_id time_zone)

    let(:email) { 'kyle@getbetter.com' }
    let(:raw_post) { params.to_json }

    example_request '[POST] Create Enrollment' do
      explanation 'Create the Enrollment'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:enrollment][:email]).to eq(email)
    end
  end
end
