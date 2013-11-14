class CardSerializer < ViewSerializer
  self.root = false

  attributes :id, :user_id, :resource_id, :resource_type, :state, :created_at, :updated_at,
             :priority, :state_changed_at, :title, :content_type, :content_type_display,
             :share_url

  def attributes
    super.merge!(state_specific_date)
  end

  def resource_type
    if object.resource_type == 'CustomCard'
      'Content'
    else
      object.resource_type
    end
  end

  delegate :title, :content_type, :content_type_display, :share_url,
           :raw_body, :raw_preview, :card_actions, :fullscreen_actions, to: :resource

  def body
    controller.render_to_string(template: 'api/v1/cards/show',
                                layout: 'serializable',
                                formats: :html,
                                locals: {card: object, resource: resource})
  end

  def preview
    controller.render_to_string(template: 'api/v1/cards/preview',
                                layout: 'serializable',
                                formats: :html,
                                locals: {card: object, resource: resource})
  end

  private

  def resource
    @resource ||= object.resource.active_model_serializer_instance
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
