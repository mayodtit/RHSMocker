require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'UserAgreements' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  header 'User-Agent', 'test'

  let!(:user) { create(:member) }
  let!(:agreement) { create(:agreement) }
  let(:auth_token) { user.auth_token }
  let(:user_id) { user.id }

  parameter :auth_token, "Performing user's auth_token"
  parameter :user_id, "Target user's id"
  required_parameters :auth_token, :user_id

  post '/api/v1/users/:user_id/agreements' do
    parameter :agreement_id, 'ID of agreement to add'
    required_parameters :agreement_id
    scope_parameters :user_agreement, [:agreement_id]

    let(:agreement_id) { agreement.id }
    let(:raw_post) { params.to_json }

    example_request '[POST] Add an agreement to a user' do
      explanation "Returns the created user agreement object"
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      user_agreement = UserAgreement.find(body[:user_agreement][:id])
      expect(body[:user_agreement].to_json).to eq(user_agreement.as_json.to_json)
    end
  end
end
