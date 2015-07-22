require 'spec_helper'

describe TaskStepTemplate do
  it_has_a 'valid factory'

  it_validates 'presence of', :task_template
  it_validates 'presence of', :description

  describe 'ordinal validations' do
    before do
      described_class.any_instance.stub(:set_defaults)
    end

    it_validates 'presence of', :ordinal
    it_validates 'uniqueness of', :ordinal, :task_template_id
    it_validates 'numericality of', :ordinal
    it_validates 'integer numericality of', :ordinal
  end

  describe '#add_data_field_template!' do
    let!(:data_field_template) { create(:data_field_template) }
    let!(:task_template) { create(:task_template, service_template: data_field_template.service_template) }
    let!(:task_step_template) { create(:task_step_template, task_template: task_template) }

    it 'creates a task data field template' do
      expect{ task_step_template.add_data_field_template!(data_field_template) }.to change(TaskDataFieldTemplate, :count).by(1)
      task_data_field_template = TaskDataFieldTemplate.last
      expect(task_data_field_template.task_template).to eq(task_template)
      expect(task_data_field_template.data_field_template).to eq(data_field_template)
    end

    it 'creates a task step data field template' do
      expect{ task_step_template.add_data_field_template!(data_field_template) }.to change(TaskStepDataFieldTemplate, :count).by(1)
      task_step_data_field_template = TaskStepDataFieldTemplate.last
      task_data_field_template = TaskDataFieldTemplate.last
      expect(task_step_data_field_template.task_step_template).to eq(task_step_template)
      expect(task_step_data_field_template.task_data_field_template).to eq(task_data_field_template)
    end

    it 'returns the data field template' do
      expect(task_step_template.add_data_field_template!(data_field_template)).to eq(data_field_template)
    end

    context 'with a output task data field template already set up' do
      let!(:task_data_field_template) do
        create(:task_data_field_template, :output, task_template: task_template,
                                                   data_field_template: data_field_template)
      end

      it "doesn't change any task data field templates" do
        expect{ task_step_template.add_data_field_template!(data_field_template) }.to_not change(TaskDataFieldTemplate, :count)
      end

      it 'creates a task step data field template' do
        expect{ task_step_template.add_data_field_template!(data_field_template) }.to change(TaskStepDataFieldTemplate, :count).by(1)
      end

      it 'returns the data field template' do
        expect(task_step_template.add_data_field_template!(data_field_template)).to eq(data_field_template)
      end

      context 'already fully associated' do
        let!(:task_step_data_field_template) do
          create(:task_step_data_field_template, task_step_template: task_step_template,
                                                 task_data_field_template: task_data_field_template)
        end

        it "doesn't change any task data field templates" do
          expect{ task_step_template.add_data_field_template!(data_field_template) }.to_not change(TaskDataFieldTemplate, :count)
        end

        it "doesn't change any task step data field templates" do
          expect{ task_step_template.add_data_field_template!(data_field_template) }.to_not change(TaskStepDataFieldTemplate, :count)
        end

        it 'returns the data field template' do
          expect(task_step_template.add_data_field_template!(data_field_template)).to eq(data_field_template)
        end
      end
    end
  end

  describe '#remove_data_field_template!' do
    let!(:task_step_data_field_template) { create(:task_step_data_field_template) }
    let(:task_step_template) { task_step_data_field_template.task_step_template }
    let(:task_data_field_template) { task_step_data_field_template.task_data_field_template }
    let(:data_field_template) { task_data_field_template.data_field_template }

    it 'removes the task step data field template' do
      expect{ task_step_template.remove_data_field_template!(data_field_template) }.to change(TaskStepDataFieldTemplate, :count).by(-1)
      expect(TaskStepDataFieldTemplate.find_by_id(task_step_data_field_template.id)).to be_nil
    end

    it 'removes the task data field template' do
      expect{ task_step_template.remove_data_field_template!(data_field_template) }.to change(TaskDataFieldTemplate, :count).by(-1)
      expect(TaskDataFieldTemplate.find_by_id(task_data_field_template.id)).to be_nil
    end

    context 'multiple task step data field templates' do
      let!(:other_task_step_template) do
        create(:task_step_template, task_template: task_step_template.task_template,
                                    ordinal: task_step_template.ordinal + 1)
      end
      let!(:other_task_step_data_field_template) do
        create(:task_step_data_field_template, task_step_template: other_task_step_template,
                                               task_data_field_template: task_data_field_template)
      end

      it 'removes the task step data field template' do
        expect{ task_step_template.remove_data_field_template!(data_field_template) }.to change(TaskStepDataFieldTemplate, :count).by(-1)
        expect(TaskStepDataFieldTemplate.find_by_id(task_step_data_field_template.id)).to be_nil
      end

      it 'does not remove the task data field template' do
        expect{ task_step_template.remove_data_field_template!(data_field_template) }.to_not change(TaskDataFieldTemplate, :count)
        expect(TaskDataFieldTemplate.find_by_id(task_data_field_template.id)).to_not be_nil
      end
    end
  end
end
