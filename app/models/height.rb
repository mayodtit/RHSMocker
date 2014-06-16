class Height < ActiveRecord::Base
  belongs_to :user, inverse_of: :heights

  attr_accessible :user, :user_id, :amount, :taken_at

  validates :user, :amount, :taken_at, presence: true

  def self.most_recent
    order('taken_at DESC').first
  end
end
