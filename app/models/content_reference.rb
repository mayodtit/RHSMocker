class ContentReference < ActiveRecord::Base
  belongs_to :referrer, class_name: 'Content'
  belongs_to :referee, class_name: 'Content'

  attr_accessible :referrer, :referee

  validates :referrer, :referee, presence: true
  validates :referee_id, uniqueness: {scope: :referrer_id}
end
