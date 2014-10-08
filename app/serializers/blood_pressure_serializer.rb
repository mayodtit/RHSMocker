class BloodPressureSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :collection_type_id, :diastolic, :systolic, :pulse, :taken_at, :mean_arterial_pressure
end
