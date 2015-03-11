class ProviderSearchPreferences < ActiveRecord::Base
  attr_accessible :distance, :gender, :id, :insurance_uid, :lat, :lon, :specialty_uid

  validate :location_parameters_must_all_be_provided_together

  validates :distance, numericality: true, allow_nil: true
  validates :gender, inclusion: { in: %w(male female), message: "must be either male or female" }, allow_nil: true

  lat_lon_regex = /\A-?\d{1,3}.\d{3}\z/
  validates :lon, format: { with: lat_lon_regex, message: "must be in the format ###.###" }, allow_nil: true
  validates :lat, format: { with: lat_lon_regex, message: "must be in the format ###.###" }, allow_nil: true

  ## TODO validate insurance_uid, specialty_uid - verify against DataSources::BetterDoctor.insurances, DataSources::BetterDoctor.specialties ?

  def location_parameters_must_all_be_provided_together
    return if lat && lon && distance
    return if lat.blank? && lon.blank? && distance.blank?
    [:lat, :lon, :distance].each do |k|
      if self.send(k).blank?
        errors.add(k, "must be provided")
      end
    end
  end

  def has_location?
    !!(lat && lon && distance)
  end

  def to_h
    h = {}
    if has_location?
      h[:user_location] = { lat: lat, lon: lon }
      h[:distance] = distance
    end
    [:gender, :insurance_uid, :specialty_uid].each do |k|
      if v = self.send(k)
        h[k] = v
      end
    end
    h
  end
end
