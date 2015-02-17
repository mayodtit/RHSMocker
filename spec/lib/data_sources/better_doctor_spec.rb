require 'spec_helper'

describe DataSources::BetterDoctor do
  describe ".build_query_url" do
    context "when passed nil, it returns nil" do
      it { expect(DataSources::BetterDoctor.send(:build_query_url, nil)).to be_nil }
    end
    context "when passed empty string, it returns nil" do
      it { expect(DataSources::BetterDoctor.send(:build_query_url, "")).to be_nil }
    end
    context "valid inputs" do
      context "user_key" do
        subject(:user_key) do
          url = DataSources::BetterDoctor.send(:build_query_url, "foo?bar=1")
          /user_key=(.+)\z/.match(url).captures.first
        end
        it "is exactly 32 hexadecimal chars" do
          expect(/\A[a-z0-9]{32}\z/.match(user_key)).to be
        end
      end
      context "when passed args with query params" do
        subject(:url) { DataSources::BetterDoctor.send(:build_query_url, "foo?bar=1") }
        it "contructs a url" do
          expect(url.start_with?("https://api.betterdoctor.com/beta/foo?bar=1&user_key=")).to be_true
        end
      end
      context "when passed args without query params" do
        subject(:url) { DataSources::BetterDoctor.send(:build_query_url, "foo") }
        it "contructs a url" do
          expect(url.start_with?("https://api.betterdoctor.com/beta/foo?user_key=")).to be_true
        end
      end
    end
  end

  describe ".build_search_query" do
    it "ignores non-whitelisted option keys" do
      expect(DataSources::BetterDoctor.send(:build_search_query, {unused_param: true})).to eq ""
    end

    describe "standard keys" do
      [:query, :gender].each do |key|
        it "adds #{key} to query params" do
          opts = {}
          opts[key] = 123
          expect(DataSources::BetterDoctor.send(:build_search_query, opts)).to eq "#{key}=123"
        end
      end
    end

    describe "keys that require formatting" do
      let(:opts) { {user_location: { lat: "37.773", lon: "-122.413" }} }
      it "adds user_location" do
        expect(DataSources::BetterDoctor.send(:build_search_query, opts)).to eq "user_location=37.773,-122.413"
      end
      it "also adds location param if distance specified" do
        opts_with_location = opts.merge({distance: 10})
        expect(DataSources::BetterDoctor.send(:build_search_query, opts_with_location)).to eq "user_location=37.773,-122.413&location=37.773,-122.413,10"
      end
    end

    it "handles all parameters at once" do
      expected_query = "query=pediatrician&gender=female&user_location=37.773,-122.413&location=37.773,-122.413,10"
      expect(DataSources::BetterDoctor.send(:build_search_query, DataSources::BetterDoctor.send(:default_search_opts))).to eq expected_query
    end
  end

  describe ".parse_doctor_response" do

  end

  describe ".wrap_api_call" do

  end


end
