require 'spec_helper'

describe TaskTemplate do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :with_service_template

  describe 'validations' do
    before do
      described_class.any_instance.stub(:copy_title_to_name)
    end

    it_validates 'presence of', :name
    it_validates 'presence of', :title
    it_validates 'foreign key of', :service_template
    it_validates 'foreign key of', :modal_template
  end

  describe '#create_deep_copy!' do
    let(:task_template) { build_stubbed(:task_template)}

    it 'creates a deep copy of the current task template' do
      task_template.should_receive(:create_deep_copy!) { task_template }

      task_template.create_deep_copy!.should == task_template
    end
  end
end
