require 'spec_helper'

describe 'TaskCategories' do
  let!(:user) { create(:pha) }
  let!(:session) { user.sessions.create }

  context 'existing record' do
    let!(:task_category) { create(:task_category) }

    describe 'GET /api/v1/task_categories' do
      def do_request
        get "/api/v1/task_categories", auth_token: session.auth_token
      end

      it 'index task_categories' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:task_categories].to_json).to eq([task_category].serializer.as_json.to_json)
      end
    end

    describe 'GET /api/v1/task_categories/:id' do
      def do_request
        get "/api/v1/task_categories/#{task_category.id}", auth_token: session.auth_token
      end

      it 'shows the task_categories' do
        do_request
        expect(response).to be_success
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:task_category].to_json).to eq(task_category.serializer.as_json.to_json)
      end
    end
  end
end
