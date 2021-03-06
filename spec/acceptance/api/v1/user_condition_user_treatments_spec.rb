require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserConditionUserTreatments" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:session) { user.sessions.create }
  let(:auth_token) { session.auth_token }
  let!(:user_condition) { create(:user_condition, :user => user) }
  let!(:user_treatment) { create(:user_treatment, :user => user) }
  let(:user_id) { user.id }
  let(:condition_id) { user_condition.id }
  let(:treatment_id) { user_treatment.id }
  let(:raw_post) { params.to_json }

  parameter :auth_token, "Performing user's auth_token"
  parameter :user_id, "Target user's id"
  required_parameters :auth_token, :user_id

  describe 'create' do
    post '/api/v1/users/:user_id/conditions/:condition_id/treatments/:treatment_id' do
      example_request "[POST] associate a treatment to a condition" do
        explanation "Returns the created association object"
        status.should == 200
        JSON.parse(response_body)['user_condition_user_treatment'].should be_a Hash
      end
    end

    post '/api/v1/users/:user_id/treatments/:treatment_id/conditions/:condition_id' do
      example_request "[POST] associate a condition to a treatment" do
        explanation "Returns the created association object"
        status.should == 200
        JSON.parse(response_body)['user_condition_user_treatment'].should be_a Hash
      end
    end
  end

  describe 'destroy' do
    before(:each) do
      create(:user_condition_user_treatment, :user_condition => user_condition,
                                           :user_treatment => user_treatment)
    end

    delete '/api/v1/users/:user_id/conditions/:condition_id/treatments/:treatment_id' do
      example_request "[DELETE] remove a treatment from a condition" do
        explanation "Deletes a condition-treatment association"
        status.should == 200
      end
    end

    delete '/api/v1/users/:user_id/treatments/:treatment_id/conditions/:condition_id' do
      example_request "[DELETE] Remove a condition from a treatment" do
        explanation "Deletes a condition-treatment association"
        status.should == 200
      end
    end
  end
end
