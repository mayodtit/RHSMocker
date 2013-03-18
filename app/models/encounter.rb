class Encounter < ActiveRecord::Base
  attr_accessible :checked, :priority, :status

  has_many :encounters_users
  has_many :messages
  has_many :users, :through=> :encounters_users

  def as_json options=nil
    {
      :status=> status,
      :priority=> priority,
      :checked => checked,
      :messages => messages
    }
  end
end
