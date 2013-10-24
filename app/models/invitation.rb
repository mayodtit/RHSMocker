class Invitation < ActiveRecord::Base
  belongs_to :member
  belongs_to :invited_member, class_name: 'Member'

  attr_accessible :member, :invited_member
  attr_accessible :member_id, :invited_member_id
  attr_accessible :token, :state

  validates :member, :invited_member, :token, presence: true
  validates :invited_member_id, :uniqueness => {:scope => :member_id}

  before_validation :generate_token, on: :create
  after_create :invite_member!

  def self.exists_for_pair?(member_id, invited_member_id)
    where(:member_id => member_id, :invited_member_id => invited_member_id).any?
  end

  def invite_member!
    invited_member.invite! self
  end

  state_machine :initial => :unclaimed do
    # When an invitation is claimed, invalidate all other invitations
    after_transition :unclaimed => :claimed do |invitation, transition|
      # TODO: This is probably not the right way to transition all these records, but
      #       nothing is listening so it should be ok.
      Invitation.where('invited_member_id = ? AND NOT token = ?',
                       invitation.invited_member_id,
                       invitation.token).update_all(state: :voided)
    end

    event :claim do
      transition :unclaimed => :claimed
    end

    event :void do
      transition :unclaimed => :voided
    end
  end

  private

  def generate_token
    self.token = Base64.urlsafe_encode64 SecureRandom.base64 36
  end
end