require 'spec_helper'

describe TaskTemplateSet do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :service_template_id
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
end
