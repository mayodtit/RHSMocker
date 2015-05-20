class SuggestedService < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :user, class_name: 'Member'
  belongs_to :suggested_service_template

  attr_accessible :user, :user_id, :suggested_service_template,
                  :suggested_service_template_id

  validates :user, :suggested_service_template, presence: true

  delegate :title, :description, :message, to: :suggested_service_template
end
