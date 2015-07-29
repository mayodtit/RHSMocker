class SuggestedServiceSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :title, :description, :message, :created_at,
             :updated_at, :suggestion_description, :suggestion_message,
             :icon_url

  alias_method :suggestion_description, :description # deprecated!
  alias_method :suggestion_message, :message # deprecated!

  delegate :user, to: :object

  def attributes
    super.tap do |attrs|
      if include_nested?
        attrs[:user] = user.try(:serializer, shallow: true).try(:as_json)
        attrs[:user_pha] = user.try(:pha).try(:serializer, shallow: true).try(:as_json)
      end
    end
  end

  private

  def include_nested?
    options[:include_nested] == true
  end

  def icon_url
    nil
  end
end
