class FactorGroup < ActiveRecord::Base
  belongs_to :symptom
  has_many :factors

  attr_accessible :symptom, :symptom_id, :name, :ordinal

  validates :symptom, :name, :ordinal, presence: true
  validates :name, uniqueness: {scope: :symptom_id}
  validates :ordinal, uniqueness: {scope: :symptom_id}

  before_validation :set_ordinal

  private

  def self.max_ordinal_for_symptom_id(symptom_id)
    where(symptom_id: symptom_id).order('ordinal DESC').first.try(:ordinal) || 0
  end

  def set_ordinal
    return true if ordinal.try(:>, 0)
    self.ordinal = self.class.max_ordinal_for_symptom_id(symptom_id) + 1
  end
end
