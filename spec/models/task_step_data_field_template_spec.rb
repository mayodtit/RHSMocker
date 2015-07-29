require 'spec_helper'

describe TaskStepDataFieldTemplate do
  it_has_a 'valid factory'

  it_validates 'presence of', :task_step_template
  it_validates 'presence of', :task_data_field_template
  it_validates 'inclusion of', :required_for_task_step_completion

  describe 'ordinal validations' do
    it_validates 'presence of', :ordinal
    it_validates 'uniqueness of', :ordinal, :task_step_template_id
    it_validates 'numericality of', :ordinal
    it_validates 'integer numericality of', :ordinal
  end

  describe '#task_data_field_template_is_output' do
    let(:task_data_field_template) { create(:task_data_field_template, type: :input) }

    it 'validates task_data_field_template is output type' do
      task_step_data_field_template = build(:task_step_data_field_template, task_data_field_template: task_data_field_template)
      expect(task_step_data_field_template).to_not be_valid
      expect(task_step_data_field_template.errors[:task_data_field_template]).to include('must be output data field')
    end
  end
end
