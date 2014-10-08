class Weight < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :amount, :bmi, :taken_at, :healthkit_uuid

  validates :user, :amount, :taken_at, presence: true

  def self.most_recent
    order('taken_at DESC').first
  end
end
