class ServiceType < ActiveRecord::Base
  BUCKETS = ['care coordination', 'engagement', 'insurance', 'wellness', 'other']
  attr_accessible :name, :bucket

  validates :name, presence: true
  validates :bucket, inclusion: { in: BUCKETS }, presence: true
end
