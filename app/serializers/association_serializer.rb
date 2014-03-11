class AssociationSerializer < ViewSerializer
  self.root = false

  attributes :id, :user_id, :associate_id, :association_type_id, :created_at, :updated_at,
             :is_default_hcp
  has_one :associate
  has_one :association_type

  delegate :user, :associate, :creator, to: :object

  def is_default_hcp
    user.default_hcp_association_id == object.id
  end

  def body
    controller.render_to_string(template: 'api/v1/cards/preview',
                                layout: 'serializable',
                                formats: :html,
                                locals: {card: nil, resource: self, current_user: scope})
  end
  alias_method :preview, :body

  def raw_body
    controller.render_to_string(template: 'api/v1/cards/preview',
                                formats: :html,
                                locals: {card: nil, resource: self, current_user: scope})
  end
  alias_method :raw_preview, :raw_body

  def title
    'Sharing Request'
  end

  def content_type
    'Association'
  end
  alias_method :content_type_display, :content_type

  def share_url
    nil
  end

  def card_actions
    []
  end

  def fullscreen_actions
    []
  end

  def timeline_action
    {}
  end
end
