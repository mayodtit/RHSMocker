class ContentSerializer < ViewSerializer
  self.root = false

  attributes :id, :title, :content_type, :content_updated_at, :document_id,
             :created_at, :updated_at, :content_type_display, :abstract,
             :contentID, :contents_type

  delegate :show_call_option?, to: :object
  alias_method :contentID, :id
  alias_method :contents_type, :content_type

  def body
    controller.render_to_string(template: 'api/v1/contents/show',
                                layout: 'serializable',
                                formats: :html,
                                locals: {content: self})
  end

  def raw_body
    object.body
  end

  def preview
    controller.render_to_string(template: 'api/v1/cards/preview',
                                layout: 'serializable',
                                formats: :html,
                                locals: {card: nil, resource: self})
  end

  def raw_preview
    object.body.split(' ').slice(0, 101).join(' ').gsub(/\ADefinition<p>/, "")
  end

  def share_url
    nil
  end
end
