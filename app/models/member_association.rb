class MemberAssociation < Association
  validate :associate_is_member

  private

  def associate_is_member
    unless associate.instance_of?(Member)
      errors.add(:associate, 'must be a member')
    end
  end

  state_machine initial: :pending
end
