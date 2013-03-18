class Encounter < ActiveRecord::Base
  attr_accessible :checked, :priority, :status

  has_many :encounters_users
  has_many :messages
  has_many :users, :through=> :encounters_users

  def as_json options=nil
    patient_user = encounters_users.patients.first.user
    {
      :id=> id,
      :status=> status,
      :priority=> priority,
      :checked => checked,
      :messages => messages.as_json(options),
      :patient_user => {
        :id=> patient_user.id,
        :full_name=> patient_user.full_name
      }
    }
  end
end
