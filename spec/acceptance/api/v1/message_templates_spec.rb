require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'MessageTemplates' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user) { create(:pha) }
  let(:user_id) { user.id }
  let(:auth_token) { user.auth_token }

  parameter :auth_token, 'User auth_token'
  required_parameters :auth_token

  context 'existing record' do
    let!(:message_template) { create(:message_template) }

    get '/api/v1/message_templates' do
      example_request '[GET] Get all MessageTemplates' do
        explanation 'Returns an array of MessageTemplates'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:message_templates].to_json).to eq([message_template].serializer.as_json.to_json)
      end
    end

    get '/api/v1/message_templates/:id' do
      let(:id) { message_template.id }

      example_request '[GET] Get MessageTemplate' do
        explanation 'Returns the MessageTemplate'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:message_template].to_json).to eq(message_template.serializer.as_json.to_json)
      end
    end

    put '/api/v1/message_templates/:id' do
      parameter :name, 'Template name'
      parameter :text, 'Message text'
      scope_parameters :message_template, [:name, :text]

      let(:name) { 'New template name' }
      let(:id) { message_template.id }
      let(:raw_post) { params.to_json }

      example_request '[PUT] Update MessageTemplate' do
        explanation 'Update the MessageTemplate'
        expect(status).to eq(200)
        body = JSON.parse(response_body, symbolize_names: true)
        expect(body[:message_template][:name]).to eq(name)
      end
    end

    delete '/api/v1/message_templates/:id' do
      let(:id) { message_template.id }
      let(:raw_post) { params.to_json }

      example_request '[DELETE] Destroy MessageTemplate' do
        explanation 'Destroy an MessageTemplate'
        expect(status).to eq(200)
      end
    end
  end

  post '/api/v1/message_templates' do
    parameter :name, 'Template name'
    parameter :text, 'Message text'
    scope_parameters :message_template, [:name, :text]

    let(:name) { 'Template name' }
    let(:text) { 'Template text' }
    let(:raw_post) { params.to_json }

    example_request '[POST] Create MessageTemplate' do
      explanation 'Create the MessageTemplate'
      expect(status).to eq(200)
      body = JSON.parse(response_body, symbolize_names: true)
      expect(body[:message_template][:name]).to eq(name)
      expect(body[:message_template][:text]).to eq(text)
    end
  end
end
