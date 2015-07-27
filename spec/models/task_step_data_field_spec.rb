require 'spec_helper'

describe TaskStepDataField do
  it_has_a 'valid factory'
  it_validates 'presence of', :task_step
  it_validates 'presence of', :task_data_field
  it_validates 'presence of', :task_step_data_field_template

  describe '#task_data_field_is_output' do
    let(:task_data_field) { create(:task_data_field, type: :input) }

    it 'validates task_data_field is output type' do
      task_step_data_field= build(:task_step_data_field, task_data_field: task_data_field)
      expect(task_step_data_field).to_not be_valid
      expect(task_step_data_field.errors[:task_data_field]).to include('must be output data field')
    end
  end
end
