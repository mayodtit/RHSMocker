class ConsultSerializer < ViewSerializer
  self.root = false

  def initialize(object, options={})
    @include_unread_messages_count = options[:include_unread_messages_count]
    super(object, options)
  end

  attributes :id, :title, :description, :initiator_id, :subject_id, :status,
             :last_message_at, :image_url, :created_at, :updated_at,
             :unread_messages_count

  def attributes
    hash = super
    hash.merge!(unread_messages_count: object.unread_messages_count) if include_unread_messages_count?
    hash
  end

  delegate :subject, to: :object

  def body
    controller.render_to_string(template: 'api/v1/cards/preview',
                                layout: 'serializable',
                                formats: :html,
                                locals: {card: nil, resource: self})
  end
  alias_method :preview, :body

  def raw_body
    controller.render_to_string(template: 'api/v1/cards/preview',
                                formats: :html,
                                locals: {card: nil, resource: self})
  end
  alias_method :raw_preview, :raw_body

  def content_type
    'Consult'
  end
  alias_method :content_type_display, :content_type

  def last_message
    @last_message ||= object.messages.order('created_at DESC').first
  end

  def last_message_at
    last_message.try(:created_at)
  end

  def share_url
    nil
  end

  def card_actions
    [
      {title: 'Save', action: :save},
      {title: 'Dismiss', action: :dismiss},
      {title: 'Reply', action: :reply}
    ]
  end

  private

  def include_unread_messages_count?
    @include_unread_messages_count || false
  end
end
