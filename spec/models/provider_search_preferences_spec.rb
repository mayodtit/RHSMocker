require 'spec_helper'

describe ProviderSearchPreferences do
  describe "#gender" do
    [nil, "male", "female"].each do |gender|
      it "when gender is #{gender}, is valid" do
        expect(ProviderSearchPreferences.new(gender: gender)).to be_valid
      end
    end
    it "is invalid with other genders" do
      expect(ProviderSearchPreferences.new(gender: "misc")).to_not be_valid
    end
  end

  describe "lat/lon format" do
    it "negative values are valid" do
      expect(ProviderSearchPreferences.new(lat: "-123.000", lon: "-80.000", distance: 1)).to be_valid
    end
    it "single digits are valid" do
      expect(ProviderSearchPreferences.new(lat: "80.000", lon: "80.000", distance: 1)).to be_valid
    end
    it "double digits are valid" do
      expect(ProviderSearchPreferences.new(lat: "7.000", lon: "3.000", distance: 1)).to be_valid
    end
    context "more than 3 digits are invalid" do
      let(:pref) do
        p = ProviderSearchPreferences.new(lat: "1000.0", lon: "3.000", distance: 1)
        p.valid?
        p
      end
      it { expect(pref).to_not be_valid }
      it { expect(pref.errors[:lat]).to eq ["must be in the format ###.###"] }
    end
    context "requires 3 decimal digits" do
      let(:pref) do
        p = ProviderSearchPreferences.new(lat: "7.0", lon: "3.000", distance: 1)
        p.valid?
        p
      end
      it { expect(pref).to_not be_valid }
      it { expect(pref.errors[:lat]).to eq ["must be in the format ###.###"] }
    end
  end

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
    it "turns regular properties into a hash" do
      pref = ProviderSearchPreferences.new(gender: "female", insurance_uid: "blue-cross", specialty_uid: "oncology")
      result = { gender: "female", insurance_uid: "blue-cross", specialty_uid: "oncology" }
      expect(pref.to_h).to eq result
    end
    it "turns location properties into a hash" do
      pref = ProviderSearchPreferences.new(lat: "37.773", lon: "-122.413", distance: 20)
      result = { user_location: { lat: "37.773", lon: "-122.413" }, distance: 20 }
      expect(pref.to_h).to eq result
    end
  end
end
