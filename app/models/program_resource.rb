class ProgramResource < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :program
  belongs_to :resource, polymorphic: true

  attr_accessible :program, :resource, :ordinal, :move_ordinal_after

  validates :program, :resource, :ordinal, presence: true
  validates :resource_id, uniqueness: {scope: [:program_id, :resource_type]}

  before_validation :set_ordinal, on: :create

  def move_ordinal_after=(item_before_id)
    ordinal_before = program_ordinal_for_program_resource_id(item_before_id)
    if has_duplicate_ordinals?
      change_ordinal_with_duplicates(ordinal_before + 1)
    elsif ordinal_before < ordinal
      decrease_ordinal(ordinal_before + 1)
    elsif ordinal_before > ordinal
      increase_ordinal(ordinal_before)
    end
  end

  private

  def set_ordinal
    self.ordinal ||= max_ordinal + 1
  end

  def max_ordinal
    self.class.where(:program_id => program.id).order('ordinal DESC').pluck(:ordinal).first || 0
  end

  def has_duplicate_ordinals?
    self.class.where(program_id: program_id, ordinal: ordinal).count > 1
  end

  def program_ordinal_for_program_resource_id(program_resource_id)
    self.class.where(program_id: program_id).find_by_id(program_resource_id).try(:ordinal) || 0
  end

  def change_ordinal_with_duplicates(target_ordinal)
    self.class.transaction do
      self.class.where(program_id: program_id).where('ordinal >= ?', target_ordinal).update_all('ordinal = ordinal + 1')
      update_attributes!(ordinal: target_ordinal)
    end
  end

  def decrease_ordinal(target_ordinal)
    self.class.transaction do
      self.class.where(program_id: program_id).where('ordinal >= ? AND ordinal < ?', target_ordinal, ordinal).update_all('ordinal = ordinal + 1')
      update_attributes!(ordinal: target_ordinal)
    end
  end

  def increase_ordinal(target_ordinal)
    self.class.transaction do
      self.class.where(program_id: program_id).where('ordinal <= ? AND ordinal > ?', target_ordinal, ordinal).update_all('ordinal = ordinal - 1')
      update_attributes!(ordinal: target_ordinal)
    end
  end
end
