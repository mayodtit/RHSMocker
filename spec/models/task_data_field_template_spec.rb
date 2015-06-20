require 'spec_helper'

describe TaskDataFieldTemplate do
  it_has_a 'valid factory'

  it_validates 'presence of', :task_template
  it_validates 'presence of', :data_field_template

  describe 'ordinal validations' do
    before do
      described_class.any_instance.stub(:set_defaults)
    end

    it_validates 'presence of', :ordinal
    it_validates 'uniqueness of', :ordinal, :task_template_id
    it_validates 'numericality of', :ordinal
    it_validates 'integer numericality of', :ordinal
  end
end
