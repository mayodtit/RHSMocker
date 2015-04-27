#Amount is in Centimeters
class Height < ActiveRecord::Base
  belongs_to :user, inverse_of: :heights
  belongs_to :creator, class_name: 'Member'

  attr_accessible :user, :user_id, :amount, :taken_at, :healthkit_uuid,
                  :healthkit_source, :creator_id, :creator

  validates :user, :amount, :taken_at, presence: true

  before_validation :set_defaults, on: :create

  def self.most_recent(time=Time.now)
    where('taken_at < ?', time).order('taken_at DESC').first
  end

  private

  def set_defaults
    self.created_at ||= Time.now # set before save, to use value in callbacks
    self.taken_at ||= created_at
  end
end
