class DataFieldChange < ActiveRecord::Base
  belongs_to :data_field, inverse_of: :data_field_changes
  belongs_to :actor, class_name: 'Member'
  serialize :data, Hash

  attr_accessible :data_field, :data_field_id, :actor, :actor_id, :data

  validates :data_field, :actor, :data, presence: true
end
