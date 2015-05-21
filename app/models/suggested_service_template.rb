class SuggestedServiceTemplate < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_many :suggested_services
  belongs_to :service_template

  attr_accessible :title, :description, :message, :service_template,
                  :service_template_id

  validates :title, :description, :message, presence: true
  validates :service_template, presence: true, if: ->(s){s.service_template_id}
end
