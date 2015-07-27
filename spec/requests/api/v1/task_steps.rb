require 'spec_helper'

describe 'TaskSteps' do
  let!(:user) { create(:pha) }
  let!(:session) { user.sessions.create }

  context 'existing record' do
    let!(:task_step) { create(:task_step) }

    describe 'GET /api/v1/task_steps/:id' do
      def do_request
        get "/api/v1/task_steps/#{task_step.id}", auth_token: session.auth_token
      end

      it 'shows the task_step' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:task_step].to_json).to eq(task_step.serializer.as_json.to_json)
      end
    end

    describe 'PUT /api/v1/task_steps/:id' do
      def do_request(params={})
        put "/api/v1/task_steps/#{task_step.id}", params.merge!(auth_token: session.auth_token)
      end

      let(:completed) { true }

      it 'updates the task_step' do
        do_request(task_step: {completed: completed})
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(task_step.reload.completed?).to be_true
        expect(body[:task_step].to_json).to eq(task_step.serializer.as_json.to_json)
      end
    end
  end
end
