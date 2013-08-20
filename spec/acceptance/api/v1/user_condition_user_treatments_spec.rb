require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "UserConditionUserTreatments" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:member) }
  let(:auth_token) { user.auth_token }
  let!(:user_condition) { create(:user_condition, :user => user) }
  let!(:user_treatment) { create(:user_treatment, :user => user) }
  let(:user_id) { user.id }
  let(:disease_id) { user_condition.id }
  let(:treatment_id) { user_treatment.id }
  let(:raw_post) { params.to_json }

  before(:each) do
    user.login
  end

  parameter :auth_token, "Performing user's auth_token"
  parameter :user_id, "Target user's id"
  required_parameters :auth_token, :user_id

  describe 'create' do
    post '/api/v1/users/:user_id/diseases/:disease_id/treatments/:treatment_id' do
      example_request "[POST] associate a treatment to a disease" do
        explanation "Returns the created association object"
        status.should == 200
        JSON.parse(response_body)['user_condition_user_treatment'].should be_a Hash
      end
    end

    post '/api/v1/users/:user_id/treatments/:treatment_id/diseases/:disease_id' do
      example_request "[POST] associate a disease to a treatment" do
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

    delete '/api/v1/users/:user_id/diseases/:disease_id/treatments/:treatment_id' do
      example_request "[DELETE] remove a treatment from a disease" do
        explanation "Deletes a disease-treatment association"
        status.should == 200
      end
    end

    delete '/api/v1/users/:user_id/treatments/:treatment_id/diseases/:disease_id' do
      example_request "[DELETE] Remove a disease from a treatment" do
        explanation "Deletes a disease-treatment association"
        status.should == 200
      end
    end
  end
end
