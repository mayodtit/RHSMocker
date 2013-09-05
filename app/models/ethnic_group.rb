class EthnicGroup < ActiveRecord::Base
  include SoftDeleteModule

  has_many :users

  attr_accessible :name, :ethnicity_code, :ordinal

  validates :name, :ethnicity_code, :ordinal, presence: true
  validates :ordinal, uniqueness: true

  before_validation :set_ordinal
  before_validation :set_ethnicity_code

  private

  def self.max_ordinal
    order('ordinal DESC').first.try(:ordinal) || 0
  end

  def set_ordinal
    return true if ordinal.try(:>, 0)
    self.ordinal = self.class.max_ordinal + 1
  end

  def self.max_ethnicity_code
    order('ethnicity_code DESC').first.try(:ethnicity_code) || 0
  end

  def set_ethnicity_code
    return true if ethnicity_code.try(:>, 0)
    self.ethnicity_code = self.class.max_ethnicity_code + 1
  end
end
