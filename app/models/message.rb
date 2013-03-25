class Message < ActiveRecord::Base
  attr_accessible :text, :content_id

  has_many :message_statuses

  has_many :attachments

  has_many :mayo_vocabularies_messages
  has_many :mayo_vocabularies, :through => :mayo_vocabularies_messages

  belongs_to :user
  belongs_to :encounter
  belongs_to :user_location
  belongs_to :content

  def as_json options=nil
    statuses = []
    if options[:current_user].present?
      statuses = message_statuses.where(:user_id=>options[:current_user].id)
    end
    result = {
      :id => id,
      :text=>text,
      :created_at=>created_at,
      :user=>{
        :id=> user.id,
        :full_name=> user.full_name
      },
      :location => user_location,
      :attachments => attachments,
      :keywords => mayo_vocabularies,
      :content_id=> content_id
    }
    if statuses.empty?
      result.merge!({status:"unread"})
    else 
      result.merge!({status:statuses.first.status})
    end
    result
  end
end
