class MemberAssociation < Association
  belongs_to :pair, class_name: 'MemberAssociation',
                    inverse_of: :inverse_pair,
                    dependent: :destroy
  has_one :inverse_pair, class_name: 'MemberAssociation',
                         foreign_key: :pair_id,
                         inverse_of: :pair

  attr_accessible :state, :pair, :pair_id

  validates :pair, presence: true, if: lambda{|a| a.pair_id}
  validate :associate_is_member

  private

  def associate_is_member
    unless associate.instance_of?(Member)
      errors.add(:associate, 'must be a member')
    end
  end

  state_machine initial: :pending do
    before_transition :pending => :enabled do |association, transition|
      association.pair = association.class.new(user_id: association.associate_id,
                                               associate_id: association.user_id,
                                               pair_id: association.id,
                                               state: :enabled)
    end
  end
end
