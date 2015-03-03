class ServiceType < ActiveRecord::Base
  BUCKETS = ['care coordination', 'engagement', 'insurance', 'wellness', 'other']
  NON_ENGAGEMENT_BUCKETS = ['care coordination', 'insurance', 'wellness', 'other']

  attr_accessible :name, :bucket, :description_template

  validates :name, presence: true
  validates :bucket, inclusion: { in: BUCKETS }, presence: true

  def self.non_engagement_ids
    where(bucket: NON_ENGAGEMENT_BUCKETS).pluck(:id)
  end
end
