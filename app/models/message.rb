class Message < ActiveRecord::Base
  attr_accessible :text, :content_id

  has_many :message_statuses

  has_many :attachments

  has_many :mayo_vocabularies_messages
  has_many :mayo_vocabularies, :through => :mayo_vocabularies_messages

  has_one :phone_call

  belongs_to :user
  belongs_to :encounter
  belongs_to :user_location
  belongs_to :content

  def as_json options=nil
    statuses = []
    if options[:current_user].present?
      statuses = message_statuses.where(:user_id=>options[:current_user].id).order('created_at DESC')
    end
    result = {
      :id => id,
      :text=>text,
      :created_at=>created_at,
      :user=>{
        :id=> user.id,
        :full_name=> user.full_name,
        :feature_bucket=> user.feature_bucket
      },
      :location => user_location,
      :attachments => attachments,
      :keywords => mayo_vocabularies,
      :content_id=> content_id,
      :encounter_id=> encounter.id,
      :title=>title
    }
    if statuses.empty? || statuses.first.status == "unread"
      result.merge!({status:"unread", read_date:nil})
    else 
      result.merge!({status:statuses.first.status, read_date:statuses.first.updated_at})
    end

    if options && options["source"].present?
      result.merge!({:body => options["source"]})
    end
    result
  end

  def previewText
    if !text.nil?
      preview = text.split(' ').slice(0, 21).join(' ')+"&hellip;"
    end
  end

  def title
    "Conversation with HCP"
  end
end
