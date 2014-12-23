class Association < ActiveRecord::Base
  belongs_to :user, inverse_of: :associations
  belongs_to :associate, class_name: 'User',
                         inverse_of: :inverse_associations
  belongs_to :creator, class_name: 'User'
  belongs_to :association_type
  belongs_to :replacement, class_name: 'Association',
                           inverse_of: :original
  has_one :original, class_name: 'Association',
                     foreign_key: :replacement_id,
                     inverse_of: :replacement
  belongs_to :pair, class_name: 'Association'
  has_one :permission, foreign_key: :subject_id,
                       dependent: :destroy,
                       inverse_of: :subject
  belongs_to :parent, class_name: 'Association',
                      inverse_of: :children
  has_many :children, class_name: 'Association',
                      foreign_key: :parent_id,
                      inverse_of: :parent,
                      dependent: :destroy
  has_many :cards, as: :resource, dependent: :destroy

  attr_accessor :is_default_hcp
  attr_accessor :invite
  attr_accessor :actor_id

  attr_accessible :user, :user_id, :associate, :associate_id,
                  :creator, :creator_id,
                  :association_type, :association_type_id,
                  :associate_attributes, :is_default_hcp, :replacement,
                  :replacement_id, :original, :state_event, :state, :pair,
                  :pair_id, :invite, :parent, :parent_id, :actor_id

  validates :user, :associate, :creator, :permission, presence: true
  validates :associate_id, uniqueness: {scope: [:user_id, :association_type_id]}
  validates :association_type, presence: true, if: ->(a){a.association_type_id}
  validates :replacement, presence: true, if: lambda{|a| a.replacement_id}
  validates :pair, presence: true, if: lambda{|a| a.pair_id}
  validates :parent, presence: true, if: lambda{|a| a.parent_id}
  validate :user_is_not_associate
  validate :creator_id_not_changed
  validates_associated :permission

  before_validation :nullify_pair_id
  before_validation :build_related_associations, on: :create
  before_validation :create_default_permission, on: :create
  after_save :invite!, if: ->(a){a.invite == true}
  after_create :send_card!
  after_create :dismiss_related_card!
  after_destroy :enable_original_association
  after_destroy :destroy_related_associations

  after_destroy :track_destroy
  after_create :track_create

  # adding and removing the user's default HCP
  after_save :process_default_hcp
  before_destroy :remove_user_default_hcp_if_necessary

  after_commit :publish

  accepts_nested_attributes_for :associate

  def self.enabled
    where(state: :enabled)
  end

  def self.pending
    where(state: :pending)
  end

  def self.enabled_or_pending
    where(state: %i(enabled pending))
  end

  def invite!
    return if replacement || (associate == associate.member)
    self.invite = false
    transaction do
      update_attributes!(replacement: build_replacement(user_id: user_id,
                                                        associate_id: associate.member_or_invite!(user).id,
                                                        creator_id: user_id,
                                                        association_type_id: association_type.try(:id) || AssociationType.family_default_id,
                                                        state: 'pending'))
      create_pair_association!
    end
  end

  def create_pair_association!
    update_attributes!(pair: build_pair(user_id: associate_id,
                                        associate_id: user_id,
                                        association_type_id: AssociationType.family_default_id,
                                        creator_id: associate_id,
                                        pair_id: id,
                                        original: original.try(:pair),
                                        state: 'enabled'))
  end

  def initial_state
    if !associate || !associate.persisted? || (creator_id == user_id) || associate.npi_number.present?
      :enabled
    else
      :pending
    end
  end

  def enable_association_with_owner!
    owner_association = self.class.where(user_id: associate.owner_id, associate_id: user_id).first
    if owner_association.try(:state?, :pending)
      owner_association.update_attributes(state_event: :enable)
    end
  end

  def possessive_association_type_display_name
    "#{creator.gender_possessive} #{association_type.display_name}"
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
    if creator_id_changed? && persisted? && !id_changed?
      errors.add(:creator_id, 'cannot be changed')
    end
  end

  def find_and_invite_parent!
    self.class.where(user_id: creator_id, associate_id: user_id).first.tap{|a| a.invite!}
  end

  def nullify_pair_id
    self.pair_id = nil unless pair
  end

  def build_related_associations
    return if !associate.persisted? || (creator_id == user_id) || associate.npi_number.present?
    transaction do
      parent = find_and_invite_parent!
      return if replacement || (user == user.member)
      update_attributes!(replacement: build_replacement(user_id: user.member_or_invite!(creator).id,
                                                        associate_id: associate_id,
                                                        association_type_id: AssociationType.family_default_id,
                                                        creator_id: creator_id,
                                                        parent: parent.replacement,
                                                        state: 'pending'))
    end
  end

  def create_default_permission
    self.permission ||= if original.try(:permission) && (associate_id == original.associate_id)
                          create_permission(original.permission.current_levels)
                        elsif user_id == associate.owner_id
                          create_permission(Permission.max_levels)
                        else
                          create_permission(Permission.default_levels)
                        end
  end

  def send_card!
    return if associate.associations
                       .joins(associate: :owner)
                       .where(state: :pending)
                       .where(owners_users: {id: user_id}).any?
    if pending?
      if (creator != user) && (user.is_a?(Member))
        user.cards.create(resource: self, priority: 20)
      elsif (creator != associate) && (associate.is_a?(Member))
        associate.cards.create(resource: self, priority: 20)
      end
    end
  end

  def dismiss_related_card!
    return if associate_id == associate.owner_id
    ids = user.inverse_associations.where(user_id: associate.owner_id).map(&:id)
    Card.where(resource_id: ids, resource_type: 'Association').each do |c|
      c.update_attributes!(state_event: :dismissed)
    end
  end

  def enable_original_association
    if enabled? && original && (associate_id != original.associate_id)
      original.enable!
    end
  end

  def destroy_related_associations
    if replacement.try(:pending?) && !replacement.marked_for_destruction?
      replacement.mark_for_destruction
      replacement.destroy
    end
    associate.destroy if associate.owner_id == user_id
    if associate_id == original.try(:associate_id) && !original.marked_for_destruction?
      original.mark_for_destruction
      original.destroy
    end
    if pair && !pair.marked_for_destruction? && (pair.user_id != pair.associate.owner_id)
      pair.mark_for_destruction
      pair.destroy
    elsif pair && !pair.marked_for_destruction? && (pair.user_id == pair.associate.owner_id) && pair.replacement.try(:pending?) && !pair.replacement.marked_for_destruction?
      pair.replacement.mark_for_destruction
      pair.replacement.destroy
    end
  end

  def invited?
    associate.member ? Invitation.exists_for_pair?(user_id, associate.member.id) : false
  end

  def process_default_hcp
    if is_default_hcp.to_s == 'true'
      user.set_default_hcp(id)
    elsif is_default_hcp.to_s == 'false'
      remove_user_default_hcp_if_necessary
    end
  end

  def remove_user_default_hcp_if_necessary
    if user.default_hcp_association_id == id
      user.remove_default_hcp
    end
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
      association.enable_association_with_owner!
      association.create_pair_association!
    end

    after_transition :pending => :enabled do |association, transition|
      if association.original
        association.original.update_attributes!(state_event: :disable)
        if association.associate_id == association.original.associate_id
          association.permission.copy_levels!(association.original.permission)
        end
      end
    end

    after_transition any - :disabled => :disabled do |association, transition|
      if association.original
        association.original.update_attributes!(state_event: :enable)
      end
      if association.pair
        association.pair.update_attributes!(state_event: :disable)
      end
    end
  end

  def track_create
    UserChange.create! user: user, actor_id: creator_id, action: 'add', data: {associations: [associate.id]}.to_s if creator.is_a? Member
  end

  def track_destroy
    UserChange.create! user: user, actor_id: actor_id, action: 'destroy', data: {associations: [associate.id]}.to_s  if actor_id
  end

  def publish
    PubSub.publish "/associations/update", { user_id: user_id }
  end
end
