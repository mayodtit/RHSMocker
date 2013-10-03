class PhoneCallSummary < ActiveRecord::Base
  belongs_to :caller, class_name: 'Member'
  belongs_to :callee, class_name: 'Member'

  attr_accessible :caller, :caller_id, :callee, :callee_id, :body

  validates :caller, :callee, :body, presence: true
end
