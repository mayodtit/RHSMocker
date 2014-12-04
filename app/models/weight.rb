class Weight < ActiveRecord::Base
  belongs_to :user
  belongs_to :creator, class_name: 'Member'

  attr_accessible :user, :user_id, :amount, :bmi, :taken_at, :healthkit_uuid,
                  :healthkit_source, :creator_id, :creator

  validates :user, :amount, :taken_at, presence: true

  def self.most_recent
    order('taken_at DESC').first
  end
end
