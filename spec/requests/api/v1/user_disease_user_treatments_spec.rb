require 'spec_helper'

describe 'UserDiseaseUserTreatments' do
  let!(:user) { create(:member) }
  let!(:user_disease) { create(:user_disease, :user => user) }
  let!(:user_disease_treatment) { create(:user_disease_treatment, :user => user) }

  before(:each) do
    user.login
  end

  describe 'creating a record' do
    describe 'POST /api/v1/users/:user_id/diseases/:disease_id/treatments/:id' do
      def do_request(params={})
        post "/api/v1/users/#{user.id}/diseases/#{user_disease.id}/treatments/#{user_disease_treatment.id}", params.merge!(auth_token: user.auth_token)
      end

      it 'creates a new record' do
        lambda{ do_request }.should change(UserConditionUserTreatment, :count).by(1)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:user_disease_user_treatment][:user_disease_id].should == user_disease.id
        body[:user_disease_user_treatment][:user_disease_treatment_id].should == user_disease_treatment.id
      end
    end

    describe 'POST /api/v1/users/:user_id/diseases/:disease_id/treatments/:id' do
      def do_request(params={})
        post "/api/v1/users/#{user.id}/treatments/#{user_disease_treatment.id}/diseases/#{user_disease.id}", params.merge!(auth_token: user.auth_token)
      end

      it 'creates a new record' do
        lambda{ do_request }.should change(UserConditionUserTreatment, :count).by(1)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:user_disease_user_treatment][:user_disease_id].should == user_disease.id
        body[:user_disease_user_treatment][:user_disease_treatment_id].should == user_disease_treatment.id
      end
    end
  end

  describe 'destroying a record' do
    before(:each) do
      create(:user_disease_user_treatment, :user_disease => user_disease,
                                           :user_disease_treatment => user_disease_treatment)
    end

    describe 'DELETE /api/v1/users/:user_id/diseases/:disease_id/treatments/:id' do
      def do_request(params={})
        delete "/api/v1/users/#{user.id}/diseases/#{user_disease.id}/treatments/#{user_disease_treatment.id}", params.merge!(auth_token: user.auth_token)
      end

      it 'deletes the record' do
        lambda{ do_request }.should change(UserConditionUserTreatment, :count).by(-1)
        response.should be_success
      end
    end

    describe 'DELETE /api/v1/users/:user_id/treatments/:treatment_id/diseases/:id' do
      def do_request(params={})
        delete "/api/v1/users/#{user.id}/treatments/#{user_disease_treatment.id}/diseases/#{user_disease.id}", params.merge!(auth_token: user.auth_token)
      end

      it 'deletes the record' do
        lambda{ do_request }.should change(UserConditionUserTreatment, :count).by(-1)
        response.should be_success
      end
    end
  end
end
