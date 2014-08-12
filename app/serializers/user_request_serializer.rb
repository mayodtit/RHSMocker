class UserRequestSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :user_id, :subject_id, :name, :request_data

  has_one :user, embed: :objects
  has_one :subject, embed: :objects
  has_one :user_request_type

  def request_data
    object.request_data.tap do |hash|
      hash[:provider] = provider_body(hash[:provider_id]) if hash[:provider_id]
    end
  end

  private

  def provider_body(id)
    User.find(id).as_json(only: %i(first_name last_name email npi_number phone))
  end
end
