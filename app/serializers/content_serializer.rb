class ContentSerializer < ViewSerializer
  self.root = false

  attributes :id, :title, :content_type, :content_updated_at, :document_id,
             :created_at, :updated_at, :content_type_display, :abstract,
             :contentID, :contents_type, :state, :state_events,
             :card_actions, :fullscreen_actions, :condition_id

  delegate :show_mayo_copyright?, :show_call_option?, :show_mayo_logo?,
           :has_custom_card?, to: :object
  alias_method :contentID, :id
  alias_method :contents_type, :content_type

  def title
    object.title.gsub("&mdash;", "-")
  end

  def body
    controller.render_to_string(template: 'api/v1/contents/show',
                                layout: 'serializable',
                                formats: :html,
                                locals: {content: self})
  end

  def raw_body
    object.raw_body
  end

  def preview
    controller.render_to_string(template: 'api/v1/cards/preview',
                                layout: 'serializable',
                                formats: :html,
                                locals: {card: nil, resource: self, current_user: scope})
  end

  def raw_preview
    object.raw_preview.present? ? object.raw_preview : raw_body.split(' ').slice(0, 101).join(' ').gsub(/\ADefinition<p>/, "")
  end

  def share_url
    nil
  end

  def card_actions
    if has_custom_card?
      object.card_actions
    else
      default_card_actions
    end
  end

  def fullscreen_actions
    [
      {normal: {title: 'Save', action: :save}, selected: {title: 'Dismiss', action: :dismiss}},
    ]
  end

  def timeline_action
    {
      action: 'openContent',
      arguments: {id: object.id}
    }
  end

  def partial_name
    'content'
  end
end
