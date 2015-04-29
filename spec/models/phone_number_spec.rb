require 'spec_helper'

describe PhoneNumber do
  it_has_a 'valid factory', :user_phone
  it_has_a 'valid factory', :address_phone

  it_validates 'presence of', :phoneable

  let(:user) { create(:user) }

  describe ".not_blacklisted?" do
    ["7378742833","0000123456","2562533","8656696","266696687"].each do |blacklisted_num|
      it "returns false if it is a blacklisted phone number" do
        expect(PhoneNumber.new(number: blacklisted_num).not_blacklisted?).to be_false
        expect(PhoneNumber.not_blacklisted?(blacklisted_num)).to be_false
      end
    end

    it "returns true for valid numbers" do
      valid_phone_number = "4083913578"
      expect(PhoneNumber.new(number: valid_phone_number).not_blacklisted?).to be_true
      expect(PhoneNumber.not_blacklisted?(valid_phone_number)).to be_true
    end
  end

  describe "#type" do
    PhoneNumber::PHONE_NUMBER_TYPES.each do |phone_number_type|
      context "Phone number type #{phone_number_type}" do
        let(:phone_number) { PhoneNumber.new(type: phone_number_type, number: "4255551111", phoneable: user) }
        it "is valid" do
          expect(phone_number).to be_valid
        end

      end
    end

    context "Without phone number type" do
      let(:phone_number) { PhoneNumber.new(type: nil, number: "4255551111", phoneable: user) }
      it "is not valid" do
        expect(phone_number).to_not be_valid
        expect(phone_number.errors[:type]).to eq [" is not a valid phone number type"]
      end
    end
  end

  describe "#number" do
    let(:phone_number) { PhoneNumber.new(type: "Home", number: test_number, phoneable: user) }
    context "Without area code" do
      let(:test_number) { "555-1111" }
      it "is not valid" do
        expect(phone_number).to_not be_valid
        expect(phone_number.errors[:number]).to eq ["is invalid"]
      end
    end

    context "With area code" do
      let(:test_number) { "(425) 555-1111" }
      it "is valid" do
        expect(phone_number).to be_valid
      end
    end
  end
end
