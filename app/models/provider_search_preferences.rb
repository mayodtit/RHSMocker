class ProviderSearchPreferences < ActiveRecord::Base
  attr_accessible :distance, :gender, :id, :insurance_uid, :lat, :lon, :specialty_uid

  validate :location_parameters_must_all_be_provided

  def location_parameters_must_all_be_provided
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
