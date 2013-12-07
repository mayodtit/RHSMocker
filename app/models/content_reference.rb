class ContentReference < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :referrer, class_name: 'Content'
  belongs_to :referee, class_name: 'Content'

  attr_accessible :referrer, :referrer_id, :referee, :referee_id

  validates :referrer, :referee, presence: true
  validates :referee_id, uniqueness: {scope: :referrer_id}
end
