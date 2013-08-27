class Consult < ActiveRecord::Base
  belongs_to :initiator, :class_name => 'Member'
  belongs_to :subject, :class_name => 'User'
  has_many :consult_users
  has_many :users, :through => :consult_users
  has_many :messages
  has_many :scheduled_phone_calls, :through => :messages
  has_many :phone_calls, :through => :messages
  has_many :cards, :as => :resource, :dependent => :destroy

  attr_accessible :initiator, :initiator_id, :subject, :subject_id, :checked,
                  :priority, :status, :add_user, :messages, :message,
                  :scheduled_phone_call, :phone_call, :title

  validates :title, :initiator, :subject, :status, :priority, presence: true
  validates :subject_id, :uniqueness => {:scope => :initiator_id}
  validates :checked, :inclusion => {:in => [true, false]}
  validates :users, :length => {:minimum => 1}

  before_validation :set_defaults

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

  def serializable_hash(options=nil)
    super(options || {:include => :message})
  end

  def members
    users.where(:type => 'Member')
  end

  def content_type
    'Consult'
  end

  def preview
    messages.last.try(:preview) || ''
  end

  def notify_members
    messages.unread_user_ids.each do |id|
      cards.upsert_attributes({:user_id => id},
                              {:state_event => :reset})
    end
  end

  private

  def set_defaults
    self.status ||= 'open'
    self.priority ||= 'medium'
    self.checked = false if checked.nil?
    self.title = "Consult for #{subject.first_name}" unless self.title.present?
    true
  end
end
