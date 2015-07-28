class SuggestedServiceTemplate < ActiveRecord::Base
  belongs_to :service_template
  has_many :suggested_services
  has_many :onboarding_group_suggested_service_templates, inverse_of: :suggested_service_template
  has_many :onboarding_groups, through: :onboarding_group_suggested_service_templates

  attr_accessible :title, :description, :message, :service_template,
                  :service_template_id

  validates :title, :description, :message, presence: true
  validates :service_template, presence: true, if: ->(s){s.service_template_id}
end
