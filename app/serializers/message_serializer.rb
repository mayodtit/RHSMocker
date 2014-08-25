class MessageSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :text, :created_at, :consult_id, :title, :image_url, :type,
             :content_id, :symptom_id, :condition_id, :note, :user_image_id,
             :contents

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
    object.user_image.try(:url) || object.image.url
  end

  def type
    if object.phone_call_id || object.scheduled_phone_call_id ||
       object.phone_call_summary_id || object.system
      :system
    else
      :user
    end
  end

  def contents
    if object.content.try(:show_mayo_logo?)
      [
        {
          id: object.content.id,
          title: object.content.title,
          image_url: root_url + mayo_logo_asset_path
        }
      ]
    elsif object.content
      [
        {
          id: object.content.id,
          title: object.content.title,
          image_url: root_url + better_logo_asset_path
        }
      ]
    else
      []
    end
  end

  def root_url
    if protocol.present? && host.present?
      protocol + '://' + host
    else
      ''
    end
  end

  def protocol
    Rails.application.routes.default_url_options[:protocol]
  end

  def host
    Rails.application.routes.default_url_options[:host]
  end

  def mayo_logo_asset_path
    ActionController::Base.helpers.asset_path('mayologo_card_@2x.png')
  end

  def better_logo_asset_path
    ActionController::Base.helpers.asset_path('logohalf@2x.png')
  end
end
