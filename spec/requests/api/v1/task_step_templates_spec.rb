require 'spec_helper'

describe 'TaskStepTemplates' do
  let!(:user) { create(:service_admin) }
  let!(:session) { user.sessions.create }

  context 'with a service template' do
    let!(:service_template) { create(:service_template) }
    let!(:task_template) { create(:task_template, service_template: service_template) }

    describe 'POST /api/v1/service_templates/:service_template_id/task_templates/:task_template_id/task_step_templates' do
      def do_request(params={})
        post "/api/v1/service_templates/#{service_template.id}/task_templates/#{task_template.id}/task_step_templates", params.merge!(auth_token: session.auth_token)
      end

      let(:description) { 'Some test description' }

      it 'creates a task step template' do
        do_request(task_step_template: {description: description})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        new_record = TaskStepTemplate.find(body[:task_step_template][:id])
        expect(body[:task_step_template]).to eq(new_record.serializer.as_json)
      end
    end

    context 'existing record' do
      let!(:task_step_template) { create(:task_step_template, task_template: task_template) }

      describe 'GET /api/v1/service_templates/:service_template_id/task_templates/:task_template_id/task_step_templates' do
        def do_request
          get "/api/v1/service_templates/#{service_template.id}/task_templates/#{task_template.id}/task_step_templates", auth_token: session.auth_token
        end

        it 'lists task step templates' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:task_step_templates]).to eq([task_step_template.serializer.as_json])
        end
      end

      describe 'GET /api/v1/service_templates/:service_template_id/task_templates/:task_template_id/task_step_templates/:task_step_template_id' do
        def do_request
          get "/api/v1/service_templates/#{service_template.id}/task_templates/#{task_template.id}/task_step_templates/#{task_step_template.id}", auth_token: session.auth_token
        end

        it 'shows the task step template' do
          do_request
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:task_step_template]).to eq(task_step_template.serializer.as_json)
        end
      end

      describe 'PUT /api/v1/service_templates/:service_template_id/task_templates/:task_template_id/task_step_templates/:task_step_template_id' do
        def do_request(params={})
          put "/api/v1/service_templates/#{service_template.id}/task_templates/#{task_template.id}/task_step_templates/#{task_step_template.id}", params.merge!(auth_token: session.auth_token)
        end

        let(:new_description) { 'Rubber baby buggie bumpers' }

        it 'updates the task step template' do
          do_request(task_step_template: {description: new_description})
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:task_step_template]).to eq(task_step_template.reload.serializer.as_json)
          updated_record = TaskStepTemplate.find(body[:task_step_template][:id])
          expect(updated_record.description).to eq(new_description)
        end
      end

      describe 'DELETE /api/v1/service_templates/:service_template_id/task_templates/:task_template_id/task_step_templates/:task_step_template_id' do
        def do_request
          delete "/api/v1/service_templates/#{service_template.id}/task_templates/#{task_template.id}/task_step_templates/#{task_step_template.id}", auth_token: session.auth_token
        end

        it 'destroys the task step template' do
          do_request
          expect(response).to be_success
          expect(TaskStepTemplate.find_by_id(task_step_template.id)).to be_nil
        end
      end
    end
  end
end
