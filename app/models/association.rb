class Association < ActiveRecord::Base
  belongs_to :user, inverse_of: :associations
  belongs_to :associate, class_name: 'User'
  belongs_to :creator, class_name: 'User'
  belongs_to :association_type
  belongs_to :replacement, class_name: 'Association',
                           inverse_of: :original
  has_one :original, class_name: 'Association',
                     foreign_key: :replacement_id,
                     inverse_of: :replacement
  belongs_to :pair, class_name: 'Association',
                    dependent: :destroy
  has_one :permission, foreign_key: :subject_id,
                       dependent: :destroy,
                       inverse_of: :subject

  attr_accessor :is_default_hcp
  attr_accessible :user, :user_id, :associate, :associate_id,
                  :creator, :creator_id,
                  :association_type, :association_type_id,
                  :associate_attributes, :is_default_hcp, :replacement,
                  :replacement_id, :original, :state_event, :state, :pair,
                  :pair_id

  validates :user, :associate, :creator, :permission, presence: true
  validates :associate_id, uniqueness: {scope: [:user_id, :association_type_id]}
  validates :replacement, presence: true, if: lambda{|a| a.replacement_id}
  validates :pair, presence: true, if: lambda{|a| a.pair_id}
  validate :user_is_not_associate
  validate :creator_id_not_changed
  validates_associated :permission

  before_validation :build_related_associations, on: :create
  before_validation :create_default_permission, on: :create
  after_save :add_user_default_hcp
  before_destroy :remove_user_default_hcp

  accepts_nested_attributes_for :associate

  def self.enabled
    where(state: :enabled)
  end

  def invite!
    return if replacement || (associate == associate.member)
    transaction do
      update_attributes!(replacement: build_replacement(user_id: user_id,
                                                        associate_id: associate.member_or_invite!(user).id,
                                                        creator_id: user_id,
                                                        association_type: association_type,
                                                        state: 'pending'))
    end
  end

  def initial_state
    if !associate || !associate.persisted? || (creator_id == user_id) || associate.npi_number.present?
      :enabled
    else
      :pending
    end
  end

  protected

  def enabled_association_with_owner
    return unless associate
    return if user_id == associate.owner_id || associate_id == associate.owner_id
    unless self.class.where(user_id: user_id, associate_id: associate.owner_id).first.try(:state?, :enabled)
      errors.add(:base, 'must have association with owner to be enabled')
    end
  end

  private

  def user_is_not_associate
    errors.add(:user, "cannot be associated to itself") if user == associate
  end

  def creator_id_not_changed
    if creator_id_changed? && persisted?
      errors.add(:creator_id, 'cannot be changed')
    end
  end

  def build_related_associations
    return if !associate.persisted? || (creator_id == user_id) || associate.npi_number.present?
    transaction do
      self.class.where(user_id: creator_id, associate_id: user_id).first.invite!
      return if replacement || (user == user.member)
      update_attributes!(replacement: build_replacement(user_id: user.member_or_invite!(creator).id,
                                                        associate_id: associate_id,
                                                        creator_id: creator_id,
                                                        state: 'pending'))
    end
  end

  def create_default_permission
    self.permission ||= create_permission(basic_info: :edit,
                                          medical_info: :edit,
                                          care_team: :edit)
  end

  def invited?
    associate.member ? Invitation.exists_for_pair?(user_id, associate.member.id) : false
  end

  def add_user_default_hcp
    user.update_attributes(default_hcp_association_id: self.id) if is_default_hcp.to_s == 'true'
  end

  def remove_user_default_hcp
    u = User.find_by_default_hcp_association_id(self.id)
    u.update_attributes(default_hcp_association_id: nil) if u
  end

  state_machine initial: lambda{|a| a.initial_state} do
    state :enabled do
      validate {|association| association.enabled_association_with_owner}
    end

    event :enable do
      transition any => :enabled
    end

    event :disable do
      transition any => :disabled
    end

    before_transition :pending => :enabled do |association, transition|
      if association.original
        association.original.update_attributes!(state_event: :disable)
      end
      association.pair = association.class.new(user_id: association.associate_id,
                                               associate_id: association.user_id,
                                               creator_id: association.associate_id,
                                               pair_id: association.id,
                                               state: :enabled)
    end

    before_transition any => :disabled do |association, transition|
      if association.original
        association.original.update_attributes!(state_event: :enable)
      end
    end
  end
end
