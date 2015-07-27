require 'spec_helper'

describe 'TaskTemplates' do
  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  let(:service_admin) { create(:service_admin) }
  let(:session) { service_admin.sessions.create }

  context 'existing record' do
    let!(:task_template) { create(:task_template) }

    describe 'GET /api/v1/task_templates' do
      def do_request
        get "/api/v1/task_templates", auth_token: session.auth_token
      end

      it 'indexes task_templates' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:task_templates].to_json).to eq([task_template].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/task_templates/:id' do
      def do_request
        get "/api/v1/task_templates/#{task_template.id}", auth_token: session.auth_token
      end

      it 'shows the task_template' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:task_template].to_json).to eq(task_template.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/task_templates/:id' do
      def do_request(params={})
        put "/api/v1/task_templates/#{task_template.id}", params.merge!(auth_token: session.auth_token)
      end

      let(:new_service_ordinal) { 1 }

      it 'updates the task_template' do
        do_request(task_template: {service_ordinal: new_service_ordinal})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(task_template.reload.service_ordinal).to eq(new_service_ordinal)
        expect(body[:task_template].to_json).to eq(task_template.serializer.as_json.to_json)
      end
    end

    describe 'DELETE /api/v1/task_templates/:id' do
      def do_request
        delete "/api/v1/task_templates/#{task_template.id}", auth_token: session.auth_token
      end

      it 'destroys the task template' do
        do_request
        expect(response).to be_success
        expect(TaskTemplate.find_by_id(task_template.id)).to be_nil
      end
    end
  end

  context 'create a new task template' do
    describe 'POST /api/v1/task_templates' do
      def do_request(params={})
        post "/api/v1/task_templates", params.merge!(auth_token: session.auth_token)
      end

      let(:task_template_attributes) { attributes_for(:task_template) }

      it 'creates a task template' do
        expect{ do_request(task_template: task_template_attributes) }.to change(TaskTemplate, :count).by(1)
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        task_template = TaskTemplate.find(body[:task_template][:id])
        expect(body[:task_template]).to eq(task_template.serializer.as_json)
      end
    end
  end
end
