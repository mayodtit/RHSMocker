require 'spec_helper'

describe PhaProfile do
  describe 'validations' do
    before do
      described_class.any_instance.stub(:set_defaults)
    end

    it_validates 'presence of', :user
    it_validates 'inclusion of', :accepting_new_members
  end

  describe 'callbacks' do
    let(:pha_profile) { described_class.new }

    it 'sets accepting_new_members to false on validation' do
      expect(pha_profile.accepting_new_members).to be_nil
      pha_profile.valid?
      expect(pha_profile.accepting_new_members).to be_false
    end
  end
end
