class AssociationType < ActiveRecord::Base
  include SoftDeleteModule

  has_many :associations

  attr_accessible :name, :gender, :relationship_type

  validates :name, :relationship_type, presence: true

  def self.by_relationship_type
    Set.new(all).classify(&:relationship_type)
  end

  def self.defaults
    {
      defaults: {
                  family: family_default_id,
                  hcp: hcp_default_id
                }
    }
  end

  def self.family_default_id
    find_by_name('Other Family Member').try(:id)
  end

  def self.hcp_default_id
    find_by_name('Care Provider').try(:id)
  end
end
