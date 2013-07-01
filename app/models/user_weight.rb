class UserWeight < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user
  attr_accessible :user_id, :weight, :bmi, :taken_at

  validates :user, :weight, :taken_at, presence: true

  before_validation :set_bmi

  private

  # metric bmi calculation is kg / m^2
  def set_bmi
    return true if !weight || !user.try(:height) || !(user.height > 0 && weight > 0)
    self.bmi = self.weight / ((user.height * 0.01)**2)
  end
end
