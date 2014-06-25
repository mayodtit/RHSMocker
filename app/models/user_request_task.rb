class UserRequestTask < Task
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :user_request

  attr_accessible :member, :member_id, :user_request, :user_request_id

  validates :member, :user_request, presence: true

  before_validation :set_owner, on: :create
end
