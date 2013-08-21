class PhoneCall < ActiveRecord::Base
  belongs_to :user, class_name: 'Member'
  has_one :message, :inverse_of => :phone_call
  has_one :scheduled_phone_call

  attr_accessible :user, :user_id, :message, :message_attributes, :origin_phone_number,
                  :destination_phone_number

  validates :user, :message, :origin_phone_number, :destination_phone_number, presence: true

  accepts_nested_attributes_for :message

  delegate :consult, :to => :message

  def self.message_params(user, consult, nested_params=nil)
    params = {user: user, consult: consult, text: 'Phone call!'}
    params.merge!(:phone_call_attributes => nested_params.merge!(:user => user)) if nested_params
    params
  end
end
