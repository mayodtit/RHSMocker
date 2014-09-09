require 'spec_helper'

describe 'Programs' do
  let!(:user) { create(:admin) }
  let(:session) { user.sessions.create }

  describe 'existing record' do
    let!(:program) { create(:program) }

    describe 'GET /api/v1/programs' do
      def do_request
        get "/api/v1/programs", auth_token: session.auth_token
      end

      it 'indexes all programs' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        ids = body[:programs].map{|p| p[:id]}
        ids.should include(program.id)
      end
    end

    describe 'GET /api/v1/programs/:id' do
      def do_request
        get "/api/v1/programs/#{program.id}", auth_token: session.auth_token
      end

      it 'shows a single program' do
        do_request
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:program][:id].should == program.id
      end
    end

    describe 'PUT /api/v1/programs/:id' do
      let(:new_title) { "New title" }

      def do_request(params={})
        put "api/v1/programs/#{program.id}", {auth_token: session.auth_token}.merge!(:program => params)
      end

      it 'shows a single program' do
        do_request(:title => new_title)
        response.should be_success
        body = JSON.parse(response.body, :symbolize_names => true)
        body[:program][:id].should == program.id
        program = Program.find(body[:program][:id])
        program.title.should == new_title
      end
    end
  end

  describe 'POST /api/v1/programs' do
    let(:title) { "title" }

    def do_request(params={})
      post "api/v1/programs", {auth_token: session.auth_token}.merge!(:program => params)
    end

    it 'creates a new program' do
      lambda{ do_request(:title => title) }.should change(Program, :count).by(1)
      response.should be_success
      body = JSON.parse(response.body, :symbolize_names => true)
      program = Program.find(body[:program][:id])
      program.title.should == title
    end
  end
end
