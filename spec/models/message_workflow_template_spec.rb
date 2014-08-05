require 'spec_helper'

describe MessageWorkflowTemplate do
  it_has_a 'valid factory'

  describe 'validations' do
    before do
      described_class.any_instance.stub(:set_defaults)
    end

    it_validates 'presence of', :message_template
    it_validates 'inclusion of', :system_message
  end
end
