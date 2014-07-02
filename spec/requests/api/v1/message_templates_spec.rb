require 'spec_helper'

describe 'MessageTemplates' do
  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  let(:pha) { create(:pha) }

  context 'existing record' do
    let!(:message_template) { create(:message_template) }

    describe 'GET /api/v1/message_templates' do
      def do_request
        get "/api/v1/message_templates", auth_token: pha.auth_token
      end

      it 'indexes message_templates' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:message_templates].to_json).to eq([message_template].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/message_templates/:id' do
      def do_request
        get "/api/v1/message_templates/#{message_template.id}", auth_token: pha.auth_token
      end

      it 'shows the message_template' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:message_template].to_json).to eq(message_template.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/message_templates/:id' do
      def do_request(params={})
        put "/api/v1/message_templates/#{message_template.id}", params.merge!(auth_token: pha.auth_token)
      end

      let(:new_text) { "Hey fatty! Why aren't your out running?" }

      it 'updates the message_template' do
        do_request(message_template: {text: new_text})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(message_template.reload.text).to eq(new_text)
        expect(body[:message_template].to_json).to eq(message_template.serializer.as_json.to_json)
      end
    end

    describe 'DELETE /api/v1/message_templates/:id' do
      def do_request
        delete "/api/v1/message_templates/#{message_template.id}", auth_token: pha.auth_token
      end

      it 'destroys the message_template' do
        do_request
        expect(response).to be_success
        expect(MessageTemplate.find_by_id(message_template.id)).to be_nil
      end
    end
  end

  describe 'POST /api/v1/message_templates' do
    def do_request(params={})
      post "/api/v1/message_templates", params.merge!(auth_token: pha.auth_token)
    end

    let(:message_template_attributes) { {name: 'New Template', text: 'hello world'} }

    it 'creates a message_template' do
      expect{ do_request(message_template: message_template_attributes) }.to change(MessageTemplate, :count).by(1)
      expect(response).to be_success
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:message_template][:name]).to eq(message_template_attributes[:name])
      expect(body[:message_template][:text]).to eq(message_template_attributes[:text])
    end
  end
end
