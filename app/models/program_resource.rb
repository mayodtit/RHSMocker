class ProgramResource < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :program
  belongs_to :resource, polymorphic: true

  attr_accessible :program, :resource, :ordinal

  validates :program, :resource, :ordinal, presence: true
  validates :resource_id, uniqueness: {scope: [:program_id, :resource_type]}

  before_validation :set_ordinal, on: :create

  private

  def set_ordinal
    self.ordinal ||= max_ordinal + 1
  end

  def max_ordinal
    self.class.where(:program_id => program.id).order('ordinal DESC').pluck(:ordinal).first || 0
  end
end
