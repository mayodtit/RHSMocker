class MessageSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :text, :created_at, :consult_id, :title, :image_url, :type, :consult_title
  has_one :user
  has_one :phone_call
  has_one :phone_call_summary
  has_one :scheduled_phone_call

  def title
    'Conversation with a Health Assistant'
  end

  def content_type
    'Message'
  end
  alias_method :content_type_display, :content_type

  def previewText
    object.text.split(' ').slice(0, 21).join(' ')+"&hellip;" if text.present?
  end
  alias_method :preview, :previewText

  def image_url
    object.image.url
  end

  def type
    if object.phone_call || object.scheduled_phone_call || object.phone_call_summary
      :system
    else
      :user
    end
  end

  def consult_title
    object.consult.title
  end
end
