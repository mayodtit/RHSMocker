class UserOffering < ActiveRecord::Base
  belongs_to :offering
  belongs_to :user
  belongs_to :phone_call

  def self.with_offering_counts
    joins(:offering).group('offerings.id').count
  end
end
