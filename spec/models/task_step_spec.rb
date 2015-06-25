require 'spec_helper'

describe TaskStep do
  it_has_a 'valid factory'
  it_validates 'presence of', :task
  it_validates 'presence of', :task_step_template

  describe 'text injection' do
    let(:key_1) { 'key_1' }
    let(:key_2) { 'key_2' }
    let(:value_1) { 'value 1' }
    let(:value_2) { 'value 2' }
    let(:placeholder_1) { "This is placeholder text with {#{key_1}} and {#{key_2}}."}
    let(:placeholder_2) { "Another placeholder text with {#{key_1}} and {#{key_2}}."}

    let!(:data_field_template_1) { create(:data_field_template, name: key_1) }
    let!(:data_field_template_2) { create(:data_field_template, name: key_2) }
    let!(:task_step_template) { create(:task_step_template, details: placeholder_1, template: placeholder_2) }

    let!(:service) { create(:service) }
    let!(:task) { create(:task, service: service) }
    let!(:data_field_1) { create(:data_field, service: service, data_field_template: data_field_template_1, data: value_1) }
    let!(:data_field_2) { create(:data_field, service: service, data_field_template: data_field_template_2, data: value_2) }
    let!(:task_data_field_1) { create(:task_data_field, task: task, data_field: data_field_1) }
    let!(:task_data_field_2) { create(:task_data_field, task: task, data_field: data_field_2) }
    let!(:task_step) { create(:task_step, task_step_template: task_step_template, task: task) }

    describe '#injected_details' do
      it 'replaces placeholder text from data values' do
        expect(task_step.injected_details).to eq("This is placeholder text with #{value_1} and #{value_2}.")
      end
    end

    describe '#injected_template' do
      it 'replaces placeholder text from data values' do
        expect(task_step.injected_template).to eq("Another placeholder text with #{value_1} and #{value_2}.")
      end
    end
  end
end
