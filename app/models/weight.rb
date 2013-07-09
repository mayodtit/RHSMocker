class Weight < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user
  attr_accessible :user_id, :amount, :bmi, :taken_at

  validates :user, :amount, :taken_at, presence: true

  before_validation :set_bmi

  def self.most_recent_for(user)
    where(:user_id => (user.try_method(:id) || user)).order('taken_at DESC').first
  end

  private

  # metric bmi calculation is kg / m^2
  def set_bmi
    return true if !amount || !user.try(:height) || !(user.height > 0 && amount > 0)
    self.bmi = self.amount / ((user.height * 0.01)**2)
  end
end
