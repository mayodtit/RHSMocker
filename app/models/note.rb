class Note < ActiveRecord::Base
  belongs_to :member
  belongs_to :creator, class_name: 'Member'

  attr_accessible :member, :member_id, :creator, :creator_id,
                  :created_at, :text

  validates :member, :creator, presence: true
end
