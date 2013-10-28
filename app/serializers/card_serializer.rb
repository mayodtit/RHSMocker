class CardSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :resource_id, :resource_type, :state, :created_at, :updated_at,
             :priority, :state_changed_at, :title, :content_type, :content_type_display,
             :share_url

  def attributes
    super.merge!(state_specific_date)
  end

  def resource
    object.resource
  end

  def title
    resource.title
  end

  def content_type
    resource.content_type
  end

  def content_type_display
    resource.content_type_display
  end

  def preview
    resource.preview
  end

  def abstract
    resource.abstract
  end

  def body
    resource.body
  end

  def share_url
    resource.try_method(:root_share_url)
  end

  def state_specific_date
    if object.saved?
      {
        :read_date => object.state_changed_at,
        :save_date => object.state_changed_at,
        :dismiss_date => ''
      }
    else
      {}
    end
  end
end
