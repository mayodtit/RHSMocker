class BloodPressure < ActiveRecord::Base
  default_scope order('taken_at DESC')

  belongs_to :user
  belongs_to :collection_type

  attr_accessible :user, :collection_type
  attr_accessible :diastolic, :systolic, :pulse, :user_id, :collection_type_id, :taken_at

  validates :user, :collection_type, :diastolic, :systolic, :taken_at, presence: true

  before_validation :set_collection_type

  def self.most_recent_for_user(user)
    where(:user_id => (user.try_method(:id) || user)).order('taken_at DESC').first
  end

  def mean_arterial_pressure
    (Float(2*diastolic+systolic)/3).round(1)
  end

  def as_json options=nil
    {
      id: id,
      diastolic: diastolic,
      systolic: systolic,
      pulse: pulse,
      mean_arterial_pressure: mean_arterial_pressure.to_s,
      collection_type_id: collection_type_id,
      taken_at: taken_at
    }
  end

  private

  def set_collection_type
    self.collection_type ||= CollectionType.self_reported
  end
end
