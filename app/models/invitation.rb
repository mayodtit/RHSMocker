class Invitation < ActiveRecord::Base
  belongs_to :member
  belongs_to :invited_member, class_name: 'Member'

  attr_accessible :member, :invited_member
  attr_accessible :member_id, :invited_member_id

  validates :member, :invited_member, presence: true
  validates :invited_member_id, :uniqueness => {:scope => :member_id}

  after_create :invite_member!

  def self.exists_for_pair?(member_id, invited_member_id)
    where(:member_id => member_id, :invited_member_id => invited_member_id).any?
  end

  def invite_member!
    invited_member.invite!
  end
end
