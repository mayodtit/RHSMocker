require 'spec_helper'

describe 'Tasks' do
  let(:pha) { create(:pha) }
  let(:session) { pha.sessions.create }

  context 'existing record' do
    let!(:service_template) { create :service_template}
    let!(:service) { create :service, service_template: service_template }
    let!(:task) { create(:task, :assigned, owner: pha, service: service, service_ordinal: 0) }

    describe 'PUT /api/v1/tasks/:id' do
      def do_request(params={})
        put "/api/v1/tasks/#{task.id}", params.merge!(auth_token: session.auth_token)
      end

      context 'claiming a task' do
        it 'claims the task' do
          expect(task).to_not be_claimed
          do_request(task: {state_event: :claim})
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:task].to_json).to eq(task.reload.serializer.as_json.to_json)
          expect(task).to be_claimed
        end

        context 'with a claimed task' do
          let!(:claimed_task) { create(:task, :claimed, owner: pha) }

          it 'unclaims other claimed tasks' do
            expect(task).to_not be_claimed
            expect(claimed_task).to be_claimed
            do_request(task: {state_event: :claim})
            expect(response).to be_success
            body = JSON.parse(response.body, symbolize_names: true)
            expect(body[:task].to_json).to eq(task.reload.serializer.as_json.to_json)
            expect(body[:updated_tasks].to_json).to eq([claimed_task.reload].serializer(shallow: true).as_json.to_json)
            expect(task).to be_claimed
            expect(claimed_task).to_not be_claimed
          end
        end
      end

      context 'completing a task' do
        it 'completes the task' do
          expect(task).to_not be_completed
          do_request(task: {state_event: :complete})
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:task].to_json).to eq(task.reload.serializer.as_json.to_json)
          expect(task).to be_completed
        end

        context 'there are tasks templates in the service template with a higher ordinal' do
          let!(:task_template) { create :task_template, service_template: service_template, service_ordinal: 1}

          context 'the completed task is the last task in its ordinal' do
            it 'should create the tasks with the next ordinal' do
              expect(task).to_not be_completed
              expect{ do_request(task: {state_event: :complete}) }.to change(Task, :count).by 2
              expect(response).to be_success
              body = JSON.parse(response.body, symbolize_names: true)
              expect(body[:task].to_json).to eq(task.reload.serializer.as_json.to_json)
              expect(body[:updated_tasks].to_json).to eq(Task.where(service_ordinal: 1).serializer(shallow: true).as_json.to_json)
              expect(task).to be_completed
            end
          end
        end
      end
    end
  end
end
