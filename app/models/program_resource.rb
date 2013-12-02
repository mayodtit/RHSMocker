class ProgramResource < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :program
  belongs_to :resource, polymorphic: true

  attr_accessible :program, :resource

  validates :program, :resource, presence: true
  validates :resource_id, uniqueness: {scope: [:program_id, :resource_type]}
end
