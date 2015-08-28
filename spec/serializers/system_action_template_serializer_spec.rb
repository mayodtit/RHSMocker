require 'spec_helper'

describe SystemActionTemplateSerializer do
  context 'message type' do
    let(:system_action_template) { create(:system_action_template, :with_content) }

    it 'renders the system action template' do
      result = system_action_template.serializer.as_json
      expect(result).to eq(
        {
          id: system_action_template.id,
          type: system_action_template.type,
          message_text: system_action_template.message_text,
          content: system_action_template.content,
          content_id: system_action_template.content_id,
          system_event_template_id: system_action_template.system_event_template_id,
          service_template: nil,
        }
      )
    end
  end
end
