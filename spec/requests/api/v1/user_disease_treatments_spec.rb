require 'spec_helper'

describe 'UserDiseaseTreatments' do
  let(:user) { create(:member) }

  before(:each) do
    user.login
  end

  context 'existing record' do
    let!(:user_disease_treatment) { create(:user_disease_treatment, :user => user) }

    describe 'GET /api/v1/users/:user_id/treatments' do
      def do_request
        get "/api/v1/users/#{user.id}/treatments", :auth_token => user.auth_token
      end

      it 'indexes the user\'s treatments' do
        other_user_disease_treatment = create(:user_disease_treatment)
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        ids = body[:user_disease_treatments].map{|c| c[:id]}
        ids.should include(user_disease_treatment.id)
        ids.should_not include(other_user_disease_treatment.id)
      end
    end

    describe 'GET /api/v1/users/:user_id/treatments/:id' do
      def do_request
        get "/api/v1/users/#{user.id}/treatments/#{user_disease_treatment.id}", :auth_token => user.auth_token
      end

      it 'shows the user\'s treatment' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:user_disease_treatment][:id].should == user_disease_treatment.id
      end
    end

    describe 'PUT /api/v1/users/:user_id/treatments/:id' do
      def do_request(params={})
        put "/api/v1/users/#{user.id}/treatments/#{user_disease_treatment.id}", {:user_disease_treatment => params}.merge!(:auth_token => user.auth_token)
      end

      let(:new_start_date) { Date.parse('04-10-1986') }

      it 'updates the user\'s treatment' do
        user_disease_treatment.start_date.should_not == new_start_date
        do_request(:start_date => new_start_date)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:user_disease_treatment][:id].should == user_disease_treatment.id
        body[:user_disease_treatment][:start_date].should == new_start_date.to_s
        user_disease_treatment.reload.start_date.should == new_start_date
      end
    end

    describe 'DELETE /api/v1/users/:user_id/treatments/:id' do
      def do_request
        delete "/api/v1/users/#{user.id}/treatments/#{user_disease_treatment.id}", :auth_token => user.auth_token
      end

      it 'deletes the user\'s treatment' do
        expect{ do_request }.to change(UserDiseaseTreatment, :count).by(-1)
        response.should be_success
      end
    end
  end

  describe 'POST /api/v1/users/:user_id/treatments' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/treatments", {:user_disease_treatment => params}.merge!(:auth_token => user.auth_token)
    end

    let!(:treatment) { create(:treatment) }
    let(:user_disease_treatment_params) { attributes_for(:user_disease_treatment, :treatment_id => treatment.id) }

    it 'creates a new treatment for the user' do
      expect{ do_request(user_disease_treatment_params) }.to change(UserDiseaseTreatment, :count).by(1)
      response.should be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      UserDiseaseTreatment.find(body[:user_disease_treatment][:id]).user.should == user
    end
  end
end
