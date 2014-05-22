class UserRequestSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :user_id, :subject_id, :name

  has_one :user_request_type
end
