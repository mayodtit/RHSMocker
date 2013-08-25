require 'spec_helper'

describe 'UserConditionUserTreatments' do
  let!(:user) { create(:member) }
  let!(:user_condition) { create(:user_condition, :user => user) }
  let!(:user_treatment) { create(:user_treatment, :user => user) }

  before(:each) do
    user.login
  end

  describe 'creating a record' do
    describe 'POST /api/v1/users/:user_id/conditions/:condition_id/treatments/:id' do
      def do_request(params={})
        post "/api/v1/users/#{user.id}/conditions/#{user_condition.id}/treatments/#{user_treatment.id}", params.merge!(auth_token: user.auth_token)
      end

      it 'creates a new record' do
        lambda{ do_request }.should change(UserConditionUserTreatment, :count).by(1)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:user_condition_user_treatment][:user_condition_id].should == user_condition.id
        body[:user_condition_user_treatment][:user_treatment_id].should == user_treatment.id
      end
    end

    describe 'POST /api/v1/users/:user_id/conditions/:condition_id/treatments/:id' do
      def do_request(params={})
        post "/api/v1/users/#{user.id}/treatments/#{user_treatment.id}/conditions/#{user_condition.id}", params.merge!(auth_token: user.auth_token)
      end

      it 'creates a new record' do
        lambda{ do_request }.should change(UserConditionUserTreatment, :count).by(1)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:user_condition_user_treatment][:user_condition_id].should == user_condition.id
        body[:user_condition_user_treatment][:user_treatment_id].should == user_treatment.id
      end
    end
  end

  describe 'destroying a record' do
    before(:each) do
      create(:user_condition_user_treatment, :user_condition => user_condition,
                                           :user_treatment => user_treatment)
    end

    describe 'DELETE /api/v1/users/:user_id/conditions/:condition_id/treatments/:id' do
      def do_request(params={})
        delete "/api/v1/users/#{user.id}/conditions/#{user_condition.id}/treatments/#{user_treatment.id}", params.merge!(auth_token: user.auth_token)
      end

      it 'deletes the record' do
        lambda{ do_request }.should change(UserConditionUserTreatment, :count).by(-1)
        response.should be_success
      end
    end

    describe 'DELETE /api/v1/users/:user_id/treatments/:treatment_id/conditions/:id' do
      def do_request(params={})
        delete "/api/v1/users/#{user.id}/treatments/#{user_treatment.id}/conditions/#{user_condition.id}", params.merge!(auth_token: user.auth_token)
      end

      it 'deletes the record' do
        lambda{ do_request }.should change(UserConditionUserTreatment, :count).by(-1)
        response.should be_success
      end
    end
  end
end
