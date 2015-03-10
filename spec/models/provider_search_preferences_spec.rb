require 'spec_helper'

describe ProviderSearchPreferences do
  describe "#location_parameters_must_all_be_provided_together" do
    it "when all location params nil, is valid" do
      expect(ProviderSearchPreferences.new(lat: nil, lon: nil, distance: nil)).to be_valid
    end
    it "when all location params provided, is valid" do
      expect(ProviderSearchPreferences.new(lat: "12.345", lon: "23.456", distance: 10)).to be_valid
    end
    context "when 2 location params provided" do
      let(:pref) { ProviderSearchPreferences.new(lat: "12.345", lon: "23.456") }
      it { expect(pref).to_not be_valid }
      it "has an error message for the missing param" do
        pref.valid?
        expect(pref.errors.messages[:distance]).to eq ["must be provided"]
      end
    end
    context "when 1 location param provided" do
      let(:pref) { ProviderSearchPreferences.new(lat: "12.345") }
      it { expect(pref).to_not be_valid }
      it "has error message for the missing params" do
        pref.valid?
        expect(pref.errors.messages[:lon]).to eq ["must be provided"]
        expect(pref.errors.messages[:distance]).to eq ["must be provided"]
      end
    end
  end

  describe "#has_location?" do
    it "when all location params present, is true" do
      expect(ProviderSearchPreferences.new(lat: "12.345", lon: "23.456", distance: 10).has_location?).to be_true
    end
    context "failing conditions" do
      it "when lat is missing" do
        expect(ProviderSearchPreferences.new(lon: "23.456", distance: 10).has_location?).to be_false
      end
      it "when lon is missing" do
        expect(ProviderSearchPreferences.new(lat: "12.345", distance: 10).has_location?).to be_false
      end
      it "when distance is missing" do
        expect(ProviderSearchPreferences.new(lat: "12.345", lon: "23.456").has_location?).to be_false
      end
    end
  end

  describe "#to_h" do

  end
end
