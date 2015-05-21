require 'spec_helper'

describe SuggestedServiceSerializer do
  let(:suggested_service) { create(:suggested_service) }

  it 'renders the suggested service' do
    result = suggested_service.serializer.as_json
    expect(result).to eq(
      {
        id: suggested_service.id,
        user_id: suggested_service.user_id,
        title: suggested_service.title,
        description: suggested_service.description,
        message: suggested_service.message,
        created_at: suggested_service.created_at,
        updated_at: suggested_service.updated_at,
        suggestion_description: suggested_service.description,
        suggestion_message: suggested_service.message
      }
    )
  end
end
