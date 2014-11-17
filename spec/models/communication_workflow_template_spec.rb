require 'spec_helper'

describe CommunicationWorkflowTemplate do
  it_has_a 'valid factory'

  describe 'validations' do
    before do
      described_class.any_instance.stub(:set_defaults)
    end

    it_validates 'presence of', :communication_workflow
    it_validates 'presence of', :relative_days
    it_validates 'presence of', :relative_hours
    it_validates 'numericality of', :relative_days
    it_validates 'numericality of', :relative_hours
  end
end
