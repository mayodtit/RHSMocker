require 'spec_helper'

describe 'UserDiseases' do
  let(:user) { create(:member) }

  before(:each) do
    user.login
  end

  context 'existing record' do
    let!(:user_disease) { create(:user_disease, :user => user) }

    describe 'GET /api/v1/users/:user_id/diseases' do
      def do_request
        get "/api/v1/users/#{user.id}/diseases", :auth_token => user.auth_token
      end

      it 'indexes the user\'s diseases' do
        other_user_disease = create(:user_disease)
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        ids = body[:user_diseases].map{|c| c[:id]}
        ids.should include(user_disease.id)
        ids.should_not include(other_user_disease.id)
      end
    end

    describe 'GET /api/v1/users/:user_id/diseases/:id' do
      def do_request
        get "/api/v1/users/#{user.id}/diseases/#{user_disease.id}", :auth_token => user.auth_token
      end

      it 'shows the user\'s disease' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:user_disease][:id].should == user_disease.id
      end
    end

    describe 'PUT /api/v1/users/:user_id/diseases/:id' do
      def do_request(params={})
        put "/api/v1/users/#{user.id}/diseases/#{user_disease.id}", {:user_disease => params}.merge!(:auth_token => user.auth_token)
      end

      let(:new_start_date) { Date.parse('04-10-1986') }

      it 'updates the user\'s disease' do
        user_disease.start_date.should_not == new_start_date
        do_request(:start_date => new_start_date)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:user_disease][:id].should == user_disease.id
        body[:user_disease][:start_date].should == new_start_date.to_s
        user_disease.reload.start_date.should == new_start_date
      end
    end

    describe 'DELETE /api/v1/users/:user_id/diseases/:id' do
      def do_request
        delete "/api/v1/users/#{user.id}/diseases/#{user_disease.id}", :auth_token => user.auth_token
      end

      it 'deletes the user\'s disease' do
        expect{ do_request }.to change(UserCondition, :count).by(-1)
        response.should be_success
      end
    end
  end

  describe 'POST /api/v1/users/:user_id/diseases' do
    def do_request(params={})
      post "/api/v1/users/#{user.id}/diseases", {:user_disease => params}.merge!(:auth_token => user.auth_token)
    end

    let!(:disease) { create(:disease) }
    let(:user_disease_params) { attributes_for(:user_disease, :disease_id => disease.id) }

    it 'creates a new disease for the user' do
      expect{ do_request(user_disease_params) }.to change(UserCondition, :count).by(1)
      response.should be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      UserCondition.find(body[:user_disease][:id]).user.should == user
    end
  end
end
