class AssociationType < ActiveRecord::Base
  has_many :associations

  attr_accessible :name, :gender, :relationship_type

  validates :name, :gender, :relationship_type, presence: true

  def self.by_relationship_type
    Set.new(all).classify(&:relationship_type)
  end
end
