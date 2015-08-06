require 'spec_helper'

describe ServiceSerializer do
  let(:service) { create(:service) }

  describe 'defaults' do
    it 'renders the service' do
      result = service.serializer.as_json
      expect(result).to eq(
        {
          id: service.id,
          member_id: service.member_id,
          user_id: service.member_id,
          owner_id: service.owner_id,
          subject_id: service.subject_id,
          service_type_id: service.service_type_id,
          state: service.state,
          title: service.title,
          description: service.description,
          due_at: service.due_at,
          created_at: service.created_at,
          updated_at: service.updated_at,
          user_facing: service.user_facing,
          service_request: service.service_request,
          service_deliverable: service.service_deliverable,
          service_update: service.service_update,
          owner_full_name: service.owner.full_name,
          service_type_name: service.service_type.name,
          time_zone: service.time_zone,
          service_type: service.service_type.serializer.as_json,
          member: service.member.serializer(shallow: true).as_json,
          subject: service.subject.serializer(shallow: true).as_json,
          owner: service.owner.serializer(shallow: true).as_json
        }
      )
    end
  end

  describe 'include_nested' do
    it 'renders the nested models' do
      result = service.serializer(include_nested: true).as_json
      expect(result).to eq(
        {
          id: service.id,
          member_id: service.member_id,
          user_id: service.member_id,
          owner_id: service.owner_id,
          subject_id: service.subject_id,
          service_type_id: service.service_type_id,
          state: service.state,
          title: service.title,
          description: service.description,
          due_at: service.due_at,
          created_at: service.created_at,
          updated_at: service.updated_at,
          user_facing: service.user_facing,
          service_request: service.service_request,
          service_deliverable: service.service_deliverable,
          service_update: service.service_update,
          owner_full_name: service.owner.full_name,
          service_type_name: service.service_type.name,
          time_zone: service.time_zone,
          service_type: service.service_type.serializer.as_json,
          member: service.member.serializer(shallow: true).as_json,
          subject: service.subject.serializer(shallow: true).as_json,
          owner: service.owner.serializer(shallow: true).as_json,
          tasks: [],
          data_fields: []
        }
      )
    end
  end
end
