class Encounter < ActiveRecord::Base
  belongs_to :user
  has_many :messages
  has_many :phone_calls, :through => :messages
  has_many :encounter_users
  has_many :users, :through => :encounter_users

  attr_accessible :user, :user_id, :checked, :priority, :status

  validates :user, :status, presence: true
  validates :checked, :inclusion => {:in => [true, false]}

  def self.open
    where(:status => :open)
  end

  def as_json options=nil
    patient_user = encounter_users.patients.first

    result = {
      :id=> id,
      :status=> status,
      :priority=> priority,
      :checked => checked,
      :messages => messages.as_json(options)
    }

    if patient_user
      result.merge!({ 
        :patient_user => {
          :id=> patient_user.user.id,
          :full_name=> patient_user.user.full_name
        }
      })
    end

    return result
  end
end
