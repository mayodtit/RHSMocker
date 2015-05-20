class SuggestedServiceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :title, :description, :message, :created_at,
             :updated_at, :suggestion_description, :suggestion_message

  alias_method :suggestion_description, :description # deprecated!
  alias_method :suggestion_message, :message # deprecated!
end
