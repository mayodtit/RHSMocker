class Height < ActiveRecord::Base
  belongs_to :user, inverse_of: :heights
  belongs_to :creator, class_name: 'Member'

  attr_accessible :user, :user_id, :amount, :taken_at, :healthkit_uuid, :creator_id, :creator

  validates :user, :amount, :taken_at, presence: true

  def self.most_recent
    order('taken_at DESC').first
  end
end
