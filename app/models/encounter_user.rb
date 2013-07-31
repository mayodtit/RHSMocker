class EncounterUser < ActiveRecord::Base
  belongs_to :encounter
  belongs_to :user

  attr_accessible :user, :user_id, :encounter, :encounter_id, :role, :read

  validates :encounter, :user, presence: true

  def self.patients
    where(:role => :patient)
  end
end
