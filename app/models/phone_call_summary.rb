class PhoneCallSummary < ActiveRecord::Base
  belongs_to :caller, class_name: 'Member'
  belongs_to :callee, class_name: 'Member'
  has_one :message, :inverse_of => :phone_call_summary

  attr_accessible :caller, :caller_id, :callee, :callee_id, :body, :message,
                  :message_attributes

  validates :caller, :callee, :message, :body, presence: true

  accepts_nested_attributes_for :message
end
