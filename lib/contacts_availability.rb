class ContactsAvailability
  def self.has_mayo_access?(user_onboarding_group)
    user_onboarding_group.nil? || user_onboarding_group.mayo_nurse_line_access?
  end
end
