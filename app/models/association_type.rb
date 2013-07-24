class AssociationType < ActiveRecord::Base
  include SoftDeleteModule

  has_many :associations

  attr_accessible :name, :gender, :relationship_type

  validates :name, :relationship_type, presence: true

  def self.by_relationship_type
    Set.new(all).classify(&:relationship_type)
  end
end
