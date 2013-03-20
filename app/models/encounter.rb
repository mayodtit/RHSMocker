class Encounter < ActiveRecord::Base
  attr_accessible :checked, :priority, :status

  has_many :encounters_users
  has_many :messages
  belongs_to :user
  has_many :users, :through=> :encounters_users

  def as_json options=nil
    patient_user = encounters_users.patients.first
    
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
