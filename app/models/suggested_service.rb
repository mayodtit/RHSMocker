class SuggestedService < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :user, class_name: 'Member'
  belongs_to :service_template
  has_one :service_type, through: :service_template

  attr_accessible :user, :user_id, :service_template, :service_template_id

  validates :user, :service_template, presence: true
end
