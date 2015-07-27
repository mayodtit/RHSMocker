class DataField < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :service, inverse_of: :data_fields
  has_many :task_data_fields, inverse_of: :data_field
  has_many :tasks, through: :task_data_fields
  belongs_to :data_field_template, inverse_of: :data_fields
  has_many :data_field_changes, inverse_of: :data_field,
                                dependent: :destroy
  attr_accessor :actor

  attr_accessible :service, :service_id, :data_field_template,
                  :data_field_template_id, :data, :actor

  validates :service, :data_field_template, presence: true
  validates :data_field_template_id, uniqueness: {scope: :service_id}

  after_update :track_changes!

  delegate :name, :type, :required_for_service_start, to: :data_field_template

  def completed?
    data.present?
  end

  def incomplete?
    data.blank?
  end

  private

  def track_changes!
    if changes_to_track.any?
      data_field_changes.create!(actor: actor, data: changes_to_track)
    end
  end

  def changes_to_track
    changes.slice(:data)
  end
end
