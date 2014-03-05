class EmergencyContact < ActiveRecord::Base
  belongs_to :user
  belongs_to :designee, class_name: 'User'

  attr_accessible :user, :user_id, :designee, :designee_id, :name, :phone_number

  validates :user, presence: true
  validates :user_id, uniqueness: true
  validates :designee, presence: true, if: ->(e){e.designee_id}
end
