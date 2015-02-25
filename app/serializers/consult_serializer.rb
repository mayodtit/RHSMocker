class ConsultSerializer < ViewSerializer
  self.root = false

  attributes :id, :title, :description, :initiator_id, :subject_id, :state,
             :image_url, :created_at, :updated_at, :status, :subject_full_name
  
  delegate :subject, to: :object
  alias_method :status, :state

  def attributes
    super.tap do |attributes|
      attributes[:initiator] = object.initiator.try(:serializer, options.merge(shallow: true))
      attributes[:subject] = object.subject.try(:serializer, options.merge(shallow: true))
    end
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

  def content_type
    'Consult'
  end
  alias_method :content_type_display, :content_type

  def last_message(omit_user=nil)
    messages = object.messages.order('created_at DESC')
    messages = messages.where("user_id != #{omit_user.id}") if omit_user
    @last_message ||= messages.first
  end

  def last_message_at(omit_user=nil)
    last_message(omit_user).try(:created_at)
  end

  def share_url
    nil
  end

  def card_actions
    default_card_actions << {normal: {title: 'Reply', action: :reply}}
  end

  def fullscreen_actions
    []
  end

  def timeline_action
    {
      action: 'openConsult',
      arguments: {id: object.id}
    }
  end

  def image_url
    object.image.url
  end

  def subject_full_name
    object.subject && object.subject.full_name
  end
end
