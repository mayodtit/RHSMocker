require 'spec_helper'

describe 'Tasks' do
  let(:pha) { create(:pha) }
  let(:session) { pha.sessions.create }

  context 'existing record' do
    let!(:service_template) { create :service_template}
    let!(:affirmative_task_template_set) { create :task_template_set, service_template: service_template }
    let!(:task_template_set) { create :task_template_set, service_template: service_template, affirmative_child: affirmative_task_template_set }
    let!(:service) { create :service, service_template: service_template }
    let!(:task_template) { create :task_template, task_template_set: task_template_set }
    let!(:task) { create(:task, :assigned, owner: pha, service: service, task_template: task_template) }

    describe 'PUT /api/v1/tasks/:id' do
      def do_request(params={})
        put "/api/v1/tasks/#{task.id}", params.merge!(auth_token: session.auth_token)
      end

      context 'claiming a task' do
        before do
          task.unclaim!
        end

        it 'claims the task' do
          expect(task).to_not be_claimed
          do_request(task: {state_event: :claim})
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:task].to_json).to eq(task.reload.serializer.as_json.to_json)
          expect(task).to be_claimed
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

        context 'there are tasks templates in the service template with next task template sets' do
          let!(:another_task_template) { create :task_template, service_template: service_template, task_template_set: affirmative_task_template_set }
          let!(:another_task) { create(:task, :assigned, owner: pha, service: service, task_template: another_task_template) }

          context 'the completed task is the last task in the task template set' do
            it 'should create the tasks with the next task template set' do
              expect(task).to_not be_completed
              do_request(task: {state_event: :complete})
              expect(response).to be_success
              body = JSON.parse(response.body, symbolize_names: true)
              expect(body[:task].to_json).to eq(task.reload.serializer.as_json.to_json)
              expect(body[:updated_tasks][0].to_json).to eq((another_task).serializer(shallow: true).as_json.to_json)
              expect(task).to be_completed
            end
          end
        end
      end

      context 'abandoning a task' do
        it 'abandons the task' do
          expect(task).to_not be_abandoned
          do_request(task: {state_event: :abandon, reason: 'Just because'})
          expect(response).to be_success
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:task].to_json).to eq(task.reload.serializer.as_json.to_json)
          expect(task).to be_abandoned
        end
      end
    end
  end
end
