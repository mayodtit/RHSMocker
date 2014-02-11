class Association < ActiveRecord::Base
  belongs_to :user
  belongs_to :associate, :class_name => 'User'
  belongs_to :association_type
  belongs_to :replacement, class_name: 'MemberAssociation',
                           inverse_of: :original
  has_one :original, class_name: 'Association',
                     foreign_key: :replacement_id,
                     inverse_of: :replacement

  attr_accessor :default_hcp
  attr_accessible :user, :user_id, :associate, :associate_id, :association_type,
                  :association_type_id, :associate_attributes, :default_hcp,
                  :replacement, :replacement_id, :original

  validates :user, :associate, presence: true
  validates :associate_id, uniqueness: {scope: [:user_id, :association_type_id]}
  validates :replacement, presence: true, if: lambda{|a| a.replacement_id}
  validate :user_is_not_associate

  after_save :add_user_default_hcp
  before_destroy :remove_user_default_hcp

  accepts_nested_attributes_for :associate

  def invite!
    raise ActiveRecord::RecordNotFound unless associate.member # TODO -invite member if they do not exist
    update_attributes!(replacement: build_replacement(user_id: user_id,
                                                      associate_id: associate.member.id,
                                                      association_type: association_type))
  end

  private

  def user_is_not_associate
    errors.add(:user, "cannot be associated to itself") if user == associate
  end

  def invited?
    associate.member ? Invitation.exists_for_pair?(user_id, associate.member.id) : false
  end

  def add_user_default_hcp
    user.update_attributes(default_hcp_association_id: self.id) if default_hcp
  end

  def remove_user_default_hcp
    u = User.find_by_default_hcp_association_id(self.id)
    u.update_attributes(default_hcp_association_id: nil) if u
  end

  state_machine initial: :enabled do
    event :enable do
      transition any => :enabled
    end

    event :disable do
      transition any => :disabled
    end
  end
end
