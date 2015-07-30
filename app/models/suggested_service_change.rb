class SuggestedServiceChange < ActiveRecord::Base
  belongs_to :suggested_service, inverse_of: :suggested_service_changes
  belongs_to :actor, class_name: 'Member'
  serialize :data, Hash

  attr_accessible :suggested_service, :suggested_service_id, :actor, :actor_id, :event, :from, :to, :data

  validates :suggested_service, presence: true
  validates :actor, presence: true, if: -> { data.present? || %w(offer accept reject).include?(event) }
end
