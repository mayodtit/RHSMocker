class UserOffering < ActiveRecord::Base
  belongs_to :offering
  belongs_to :user
  belongs_to :phone_call

  attr_accessible :user, :offering
  attr_accessible :user_id, :offering_id, :unlimited

  def self.with_offering_counts
    joins(:offering).group('offerings.id').count
  end
end
