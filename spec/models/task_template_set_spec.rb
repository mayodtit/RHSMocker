require 'spec_helper'

describe TaskTemplateSet do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :service_template
  end

  describe '#create_association!' do
    context 'it sets affirmative child id and negative child id' do
      let(:task_template_set) { build_stubbed(:task_template_set)}

      it 'updates affirmative child id and negative child id' do
        task_template_set.should_receive(:create_association!) { task_template_set }

        task_template_set.create_association!.should == task_template_set
      end
    end
  end

  describe '#create_task_template_set!' do
    context 'it creates a deep copy of task_template_set' do
      let(:task_template_set) { build_stubbed(:task_template_set) }

      it 'creates a deep copy of task_template_set' do
        task_template_set.should_receive(:create_deep_copy!) { task_template_set }

        task_template_set.create_deep_copy!.should == task_template_set
      end
    end
  end

  describe '#create_task_templates!' do
    context 'it creates task_templates\' deep copy' do
      let(:task_template) { build_stubbed(:task_template) }

      it 'creates a deep copy of task_template_set' do
        task_template.should_receive(:create_deep_copy!) { task_template }

        task_template.create_deep_copy!.should == task_template
      end
    end
  end
end
