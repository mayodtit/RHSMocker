class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :offering

  attr_accessible :user, :user_id, :offering, :offering_id, :unlimited

  validates :user, :offering, presence: true

  def self.with_offering_counts
    joins(:offering).group('offerings.id').count
  end
end
