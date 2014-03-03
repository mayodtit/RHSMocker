class UserConditionSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :user_id, :condition_id, :start_date, :end_date, :being_treated,
             :diagnosed, :diagnosed_date, :diagnoser_id, :disease_id, :user_treatment_ids,
             :created_at, :updated_at
  has_one :condition
  has_one :disease
end
