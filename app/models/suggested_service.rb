class SuggestedService < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :user, class_name: 'Member'

  attr_accessible :user, :user_id

  validates :user, presence: true
end
