class UserRequestSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :user_id, :subject_id, :name, :request_data

  has_one :user, embed: :objects
  has_one :subject, embed: :objects
  has_one :user_request_type
end
