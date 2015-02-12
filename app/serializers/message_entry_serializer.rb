class MessageEntrySerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :sender, :receiver, :text, :created_at, :title, :image_url, :type,
             :content_id, :symptom_id, :condition_id, :user_image_id,
             :contents, :system, :note

  def sender
    object.consult.initiator.full_name
  end

  def receiver
    object.user.full_name
  end

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
    ActionController::Base.helpers.asset_path('logo_58.png')
  end
end
