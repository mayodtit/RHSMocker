class Subscription < ActiveRecord::Base
  belongs_to :owner, class_name: 'Member'

  validates :owner, presence: true, if: ->(s){s.owner_id}
end
