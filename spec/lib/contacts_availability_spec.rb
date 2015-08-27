require 'spec_helper'

describe ContactsAvailability do
  describe ".has_mayo_access?" do
    context "true" do
      it { expect(ContactsAvailability.has_mayo_access?(nil)).to be_true }
      it "for groups that are mayo_pilot" do
        mayo_pilot_group = double("onboarding group", :mayo_nurse_line_access? => true)
        expect(ContactsAvailability.has_mayo_access?(mayo_pilot_group)).to be_true
      end
    end

    context "false" do
      it "for groups that aren't mayo_pilot" do
        non_mayo_pilot_group = double("onboarding group", :mayo_nurse_line_access? => false)
        expect(ContactsAvailability.has_mayo_access?(non_mayo_pilot_group)).to be_false
      end
    end
  end
end
