class BloodPressure < ActiveRecord::Base
  default_scope order('taken_at DESC')

  belongs_to :user
  belongs_to :collection_type

  attr_accessible :user, :collection_type, :diastolic, :systolic, :pulse,
                  :user_id, :collection_type_id, :taken_at, :healthkit_uuid,
                  :healthkit_source

  validates :user, :collection_type, :diastolic, :systolic, :taken_at, presence: true

  before_validation :set_collection_type

  def self.most_recent
    order('taken_at DESC').first
  end

  def mean_arterial_pressure
    (Float(2 * diastolic + systolic) / 3).round(1).to_s
  end

  private

  def set_collection_type
    self.collection_type ||= CollectionType.self_reported
  end
end
