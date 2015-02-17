require 'spec_helper'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

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
        let(:user_key) do
          url = DataSources::BetterDoctor.send(:build_query_url, "foo?bar=1")
          /user_key=(.+)\z/.match(url).captures.first
        end
        it "is exactly 32 hexadecimal chars" do
          expect(/\A[a-z0-9]{32}\z/.match(user_key)).to be
        end
      end
      context "when passed args with query params" do
        let(:url) { DataSources::BetterDoctor.send(:build_query_url, "foo?bar=1") }
        it "contructs a url" do
          expect(url.start_with?("https://api.betterdoctor.com/beta/foo?bar=1&user_key=")).to be_true
        end
      end
      context "when passed args without query params" do
        let(:url) { DataSources::BetterDoctor.send(:build_query_url, "foo") }
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
      [:gender, :specialty_uid, :insurance_uid].each do |key|
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
      expected_query = "gender=female&user_location=37.773,-122.413&location=37.773,-122.413,10"
      expect(DataSources::BetterDoctor.send(:build_search_query, DataSources::BetterDoctor.send(:default_search_opts))).to eq expected_query
    end
  end

  describe ".parse_doctor_response" do
    ## This method receives data mid-processing and there's not a great way to generate it's input. '.lookup_by_npi' effectively tests this
  end

  describe ".parse_insurance_response" do
    ## This method receives data mid-processing and there's not a great way to generate it's input. '.insurances' effectively tests this
  end

  describe ".parse_specialty_response" do
    ## This method receives data mid-processing and there's not a great way to generate it's input. '.specialties' effectively tests this
  end

  describe ".wrap_api_call" do
    ## Successful API calls are handled in the context "API Calls" below
    context "failing API calls" do
      context "invalid API key" do
        let(:error_response) { DataSources::BetterDoctor.send(:wrap_api_call, "doctors/npi/0000000401?user_key=notreal") }
        it { expect(error_response[:error]).to eq "Invalid user_key" }
        it { expect(error_response[:error_code]).to be 1000 }
      end
    end
  end

  context "API Calls" do
    describe ".lookup_by_npi" do
      context "successful response" do
        let(:doctor) { DataSources::BetterDoctor.lookup_by_npi("1285699967") }
        it { expect(doctor[:ratings]).to eq [5] }
        it { expect(doctor[:image_url]).to eq "https://asset3.betterdoctor.com/images/531e869a4214f849610000d0-1_thumbnail.jpg" }
        ## TODO Deferring additional tests until we know what Doctor fields to use. See also .search
      end

      context "invalid npi" do
        let(:error_response) { DataSources::BetterDoctor.lookup_by_npi("0000000404") }
        it { expect(error_response[:error]).to be }
        it { expect(error_response[:error_code]).to be 9999 }
      end
    end

    describe ".search" do
      context "successful response" do
        let(:search_results) { DataSources::BetterDoctor.search(DataSources::BetterDoctor.send(:default_search_opts)) }
        it { expect(search_results.length).to eq 10 }

        context "doctor record parsing" do
          let(:doctor) { search_results.first }
          it { expect(doctor[:ratings]).to eq [nil, 5] }
          it { expect(doctor[:image_url]).to eq "https://asset4.betterdoctor.com/images/539b48fe4214f828a3000055-1_thumbnail.jpg" }
          ## TODO Deferring additional tests until we know what Doctor fields to use. See also .search
        end
      end
    end

    describe ".specialties" do
      context "successful response" do
        let(:specialties) { DataSources::BetterDoctor.specialties }
        it { expect(specialties.length).to eq 245 }

        context "specialty record parsing" do
          let(:acupuncture) { specialties.first }
          it { expect(acupuncture[:uid]).to eq "acupuncturist" }
          it { expect(acupuncture[:name]).to eq "Acupuncture" }
          it { expect(acupuncture[:category]).to eq "medical" }
        end
      end
    end

    describe ".insurances" do
      context "successful response" do
        let(:insurances) { DataSources::BetterDoctor.insurances }
        it { expect(insurances.length).to eq 77 }

        context "insurance record parsing" do
          let(:aetna) { insurances.first }
          it { expect(aetna[:uid]).to eq "aetna" }
          it { expect(aetna[:name]).to eq "Aetna" }
          it { expect(aetna[:num_plans]).to eq 41 }
        end
      end
    end
  end
end
