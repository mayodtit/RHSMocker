class MessageSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :text, :created_at, :consult_id, :title, :image_url, :type

  def title
    'Conversation with a Health Assistant'
  end

  def content_type
    'Message'
  end
  alias_method :content_type_display, :content_type

  def previewText
    text.split(' ').slice(0, 21).join(' ')+"&hellip;" if text.present?
  end
  alias_method :preview, :previewText

  def image_url
    image.url
  end

  def type
    if phone_call || scheduled_phone_call || phone_call_summary
      :system
    else
      :user
    end
  end
end
