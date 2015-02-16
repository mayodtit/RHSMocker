require 'spec_helper'

describe DataSources::BetterDoctor do
  describe ".build_query_url" do
    describe "returns nil" do
      it "if passed nil" do
        DataSources::BetterDoctor.send(:build_query_url, nil).should be_nil
      end

      it "if passed empty string" do
        DataSources::BetterDoctor.send(:build_query_url, "").should be_nil
      end
    end
    describe "constructs a url" do
      it "with query params" do
        url = "https://api.betterdoctor.com/beta/foo?bar=1&user_key=edd4c37c129961549d4f1882251b261c"
        DataSources::BetterDoctor.send(:build_query_url, "foo?bar=1").should == url
      end
      it "without query params" do
        url = "https://api.betterdoctor.com/beta/foo?user_key=edd4c37c129961549d4f1882251b261c"
        DataSources::BetterDoctor.send(:build_query_url, "foo").should == url
      end
    end
  end

  describe ".build_search_query" do
    it "ignores non-whitelisted option keys" do
      DataSources::BetterDoctor.send(:build_search_query, {unused_param: true}).should == ""
    end

    describe "standard keys" do
      [:query, :gender].each do |key|
        it "adds #{key} to query params" do
          opts = {}
          opts[key] = 123
          DataSources::BetterDoctor.send(:build_search_query, opts).should == "#{key}=123"
        end
      end
    end

    describe "keys that require formatting" do
      let(:opts) { {user_location: { lat: "37.773", lon: "-122.413" }} }
      it "adds user_location" do
        DataSources::BetterDoctor.send(:build_search_query, opts).should == "user_location=37.773,-122.413"
      end
      it "also adds location param if distance specified" do
        opts_with_location = opts.merge({distance: 10})
        DataSources::BetterDoctor.send(:build_search_query, opts_with_location).should == "user_location=37.773,-122.413&location=37.773,-122.413,10"
      end
    end

    it "handles all parameters at once" do
      DataSources::BetterDoctor.send(:build_search_query, DataSources::BetterDoctor.send(:default_search_opts)).should ==
        "query=pediatrician&gender=female&user_location=37.773,-122.413&location=37.773,-122.413,10"
    end
  end

  describe ".parse_doctor_response" do

  end

  describe ".wrap_api_call" do

  end


end
