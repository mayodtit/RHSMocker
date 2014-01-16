class CustomCardSerializer < ViewSerializer
  self.root = false

  attributes :id, :title, :content_id, :priority
  has_one :content

  def preview
    controller.render_to_string(template: 'api/v1/cards/preview',
                                layout: 'serializable',
                                formats: :html,
                                locals: {card: nil, resource: self, current_user: scope})
  end

  def raw_preview
    object.raw_preview
  end

  def body
    content.try(:body) || preview
  end

  def raw_body
    content.try(:raw_body) || raw_preview
  end

  def content_type
    content.try(:content_type) || 'CustomCard'
  end

  def content_type_display
    content.try(:content_type_display) || 'CustomCard'
  end

  def share_url
    content.try(:share_url)
  end

  def card_actions
    if content
      content.card_actions
    elsif object.card_actions.any?
      object.card_actions
    else
      [{normal: {title: 'Dismiss', action: :dismiss}}]
    end
  end

  def fullscreen_actions
    content.try(:fullscreen_actions) || []
  end

  def timeline_action
    if content
      content.timeline_action
    elsif object.timeline_action.any?
      object.timeline_action
    else
      {}
    end
  end

  def content
    @content ||= object.content.try(:serializer)
  end
end
