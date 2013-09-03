class Diet < ActiveRecord::Base
  include SoftDeleteModule

  has_many :users

  attr_accessible :name, :ordinal

  validates :name, :ordinal, presence: true
  validates :ordinal, uniqueness: true

  before_validation :set_ordinal

  private

  def self.max_ordinal
    order('ordinal DESC').first.try(:ordinal) || 0
  end

  def set_ordinal
    return true if ordinal.try(:>, 0)
    self.ordinal = self.class.max_ordinal + 1
  end
end
