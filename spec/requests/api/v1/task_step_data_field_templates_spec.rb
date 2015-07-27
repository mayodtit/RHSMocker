require 'spec_helper'

describe 'TaskStepTemplates' do
  let!(:user) { create(:service_admin) }
  let!(:session) { user.sessions.create }
  let!(:data_field_template) { create(:data_field_template) }
  let!(:task_template) { create(:task_template, service_template: data_field_template.service_template) }
  let!(:task_step_template) { create(:task_step_template, task_template: task_template) }

  describe 'POST /api/v1/task_step_templates/:task_step_template_id/data_field_templates/:data_field_template_id' do
    def do_request(params={})
      post "/api/v1/task_step_templates/#{task_step_template.id}/data_field_templates/#{data_field_template.id}", auth_token: session.auth_token
    end

    it 'creates an association between the task_step_template and data_field_template' do
      expect(task_step_template.reload.data_field_templates).to be_empty
      do_request
      expect(response).to be_success
      expect(task_step_template.reload.data_field_templates).to include(data_field_template)
    end
  end

  describe 'DELETE /api/v1/task_step_templates/:task_step_template_id/data_field_templates/:data_field_template_id' do
    def do_request(params={})
      delete "/api/v1/task_step_templates/#{task_step_template.id}/data_field_templates/#{data_field_template.id}", auth_token: session.auth_token
    end

    before do
      task_step_template.add_data_field_template!(data_field_template)
    end

    it 'removes the association between the task_step_template and data_field_template' do
      expect(task_step_template.reload.data_field_templates).to include(data_field_template)
      do_request
      expect(response).to be_success
      expect(task_step_template.reload.data_field_templates).to be_empty
    end
  end
end
