require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "TaskChanges" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:pha) { create(:pha) }
  let(:session) { pha.sessions.create }
  let!(:other_pha) { create(:pha) }
  let(:auth_token) { session.auth_token }
  let!(:task_change) { create(:task_change, actor: pha, created_at: 3.days.ago)}
  let!(:another_task_change) { create(:task_change, actor: pha, created_at: 4.days.ago)}
  let!(:yet_another_task_change) { create(:task_change, actor: other_pha, created_at: 1.days.ago)}

  describe 'tasks' do
    parameter :auth_token, 'Performing hcp\'s auth_token'
    parameter :member_id, 'PHA to retrieve tasks for'

    required_parameters :auth_token, :member_id

    let(:auth_token) { session.auth_token }
    let(:member_id) { pha.id }

    get '/api/v1/members/:member_id/task_changes' do
      example_request '[GET] Get all task changes' do
        explanation 'Get all task changes for a PHA where they are the actor, most recent first. Accessible only by HCPs'
        status.should == 200
        response = JSON.parse response_body, symbolize_names: true
        response[:task_changes].to_json.should == [task_change, another_task_change].serializer.to_json
      end
    end
  end
end