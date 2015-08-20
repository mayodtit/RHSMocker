require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "SpecialistsController" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:pha) { create(:pha) }
  let(:session) { pha.sessions.create }
  let(:auth_token) { session.auth_token }

  describe 'index' do

    parameter :auth_token, 'Performing hcp\'s auth_token'

    required_parameters :auth_token

    let!(:specialist) { create(:specialist) }
    let!(:another_specialist) { create(:specialist) }

    get '/api/v1/specialists/' do
      example_request '[GET] Get all specialists' do
        explanation 'Get all specialists and associated information'
        expect(status).to eq(200)
        response = JSON.parse response_body, symbolize_names: true
        response[:specialists].to_json.should == [specialist, another_specialist].serializer(specialist: true).to_json
      end
    end
  end

  describe 'queue' do

    parameter :auth_token, 'Performing hcp\'s auth_token'

    required_parameters :auth_token

    let!(:specialist_task) { create(:task, :unclaimed, queue: :specialist, due_at: 1.day.ago) }
    let!(:another_specialist_task) { create(:task, :unclaimed, queue: :specialist, due_at: 1.hour.ago) }

    get '/api/v1/specialists/queue' do
      example_request '[GET] Get the specialists queue' do
        explanation 'Get the specialists queue for that day'
        expect(status).to eq(200)
        response = JSON.parse response_body, symbolize_names: true
        response[:queue].to_json.should == [specialist_task, another_specialist_task].serializer(specialist: true).to_json
      end
    end
  end
end
