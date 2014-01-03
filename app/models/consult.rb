class Consult < ActiveRecord::Base
  belongs_to :initiator, :class_name => 'Member'
  belongs_to :subject, :class_name => 'User'
  has_many :consult_users
  has_many :users, :through => :consult_users
  has_many :messages
  has_many :scheduled_phone_calls, :through => :messages
  has_many :phone_calls, :through => :messages
  has_many :cards, :as => :resource, :dependent => :destroy
  belongs_to :symptom

  attr_accessible :initiator, :initiator_id, :subject, :subject_id, :checked,
                  :priority, :status, :add_user, :messages, :message, :image,
                  :scheduled_phone_call, :phone_call, :title, :description,
                  :symptom, :symptom_id

  validates :title, :initiator, :subject, :status, :priority, presence: true
  validates :symptom, presence: true, if: lambda{|c| c.symptom_id.present? }
  validates :checked, :inclusion => {:in => [true, false]}
  validates :users, :length => {:minimum => 1}

  before_validation :set_defaults

  symbolize :status, :in => [:open, :closed]

  mount_uploader :image, ConsultImageUploader

  def self.open
    where(:status => :open)
  end

  def message=(params)
    self.messages.build(params.merge!(:consult => self))
  end

  def scheduled_phone_call=(params)
    self.messages.build(Message.phone_params(:scheduled_phone_call, initiator, self, params))
  end

  def phone_call=(params)
    self.messages.build(Message.phone_params(:phone_call, initiator, self, params))
  end

  def add_user=(user)
    self.users << user unless self.users.include?(user)
  end

  def image_url
    image.url
  end

  def members
    users.where(:type => 'Member')
  end

  def notify_members
    messages.unread_user_ids.each do |id|
      cards.upsert_attributes({:user_id => id},
                              {:state_event => :reset})
    end
  end

  def self.with_unread_messages_count_for(user)
    joins('LEFT OUTER JOIN messages ON messages.consult_id = consults.id')
    .joins("LEFT OUTER JOIN message_statuses
            ON message_statuses.message_id = messages.id
            AND message_statuses.user_id = #{user.id}
            AND message_statuses.status = 'unread'")
    .select('consults.*, count(message_statuses.id) as unread_messages_count_string')
    .group('consults.id')
  end

  def unread_messages_count
    unread_messages_count_string.to_i
  end

  private

  def set_defaults
    self.status ||= :open
    self.priority ||= 'medium'
    self.checked = false if checked.nil?
    self.title = "Consult for #{subject.first_name}" unless self.title.present?
    true
  end
end
