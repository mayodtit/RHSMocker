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

  context 'normal enrollment' do
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

  context 'business on boarding enrollment' do
    post '/api/v1/enrollments' do
      parameter :email, 'User email'
      parameter :first_name, 'User first name'
      parameter :last_name, 'User last name'
      parameter :business_on_board, 'a indicator for business on boarding'
      scope_parameters :enrollment, %i(email first_name last_name business_on_board)

      let(:email) { 'kyle@getbetter.com' }
      let(:business_on_board) {'yes'}
      let(:raw_post) { params.to_json }

      example_request '[POST] Create Enrollment for business on_boarding users' do
        expect(status).to eq(200)
        expect(Enrollment.count).to eq(1)
        expect(Delayed::Job.count).to eq(1)
        expect(Enrollment.last.unique_on_boarding_user_token).not_to eq(nil)
      end
    end
  end

  context 'for business on boarding member already have credentials' do
    get '/api/v1/enrollments/on_board' do
      parameter :unique_on_boarding_user_token, 'the unique token for auth for business on_boarding users '

      required_parameters :unique_on_boarding_user_token

      let(:unique_on_boarding_user_token){ 'uout' }
      let!(:user) { create(:member, unique_on_boarding_user_token: 'uout')}

      example_request '[GET]Get user/enrollment record for business on_boarding users' do
        explanation 'Return the user_id, auth_token, and on_boarding stories'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:auth_token]).not_to eq(nil)
        expect(body[:user_id]).to eq(user.id)
      end
    end
  end

  context 'for business on boarding member without credentials' do
    get '/api/v1/enrollments/on_board' do
      parameter :unique_on_boarding_user_token, 'the unique token for auth for business on_boarding users '

      required_parameters :unique_on_boarding_user_token

      let(:unique_on_boarding_user_token){ 'uout' }
      let(:email){ 'zeev@getworse.com' }
      let!(:enrollment) { create(:enrollment, email: email, unique_on_boarding_user_token: 'uout')}

      example_request '[GET]Get user/enrollment record for business on_boarding users' do
        explanation 'Return the enrollment info and stories'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:enrollment][:email]).to eq(email)
      end
    end
  end
end
