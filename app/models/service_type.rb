class ServiceType < ActiveRecord::Base
  BUCKETS = ['insurance', 'care coordination', 'engagement', 'wellness', 'other']
  attr_accessible :name, :bucket

  validates :name, presence: true
  validates :bucket, inclusion: { in: BUCKETS }, presence: true
end
