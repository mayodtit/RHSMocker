require 'spec_helper'

describe 'TaskTemplates' do
  before do
    Timecop.freeze(Date.today.to_time)
  end

  after do
    Timecop.return
  end

  let(:pha) { create(:pha) }
  let(:session) { pha.sessions.create }

  context 'existing record' do
    let!(:task_template) { create(:task_template) }

    describe 'GET /api/v1/message_templates/:id' do
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
  end

end
