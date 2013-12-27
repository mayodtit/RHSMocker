require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Factors' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  get 'api/v1/factors/:symptom_id' do
    parameter :symptom_id, 'Symptom ID'
    required_parameters :symptom_id

    let!(:factor_group) { create(:factor_group) }
    let(:symptom) { factor_group.symptom }
    let(:symptom_id) { symptom.id }

    example_request "[DEPRECATED] [GET] Get all the factors for a symptom" do
      explanation "Returns an array of factors available for a symptom"
      expect(status).to eq(200)
      json = JSON.parse(response_body, symbolize_names: true)
      expect(json[:factor_groups].to_json).to eq([factor_group].serializer.to_json)
    end
  end

  post 'api/v1/symptoms/check' do
    parameter :symptom_id,        "Symptom id"
    parameter :symptoms_factors,  "Collection of symptoms_factor ids"
    required_parameters :symptom_id, :symptoms_factors

    let(:symptom_id)        { symptom.id }
    let(:symptoms_factors)  { [symptoms_factor.id] }
    let(:raw_post)          { params.to_json }

    example_request "[POST] Get contents ad associated symptoms factors" do
      explanation "Returns an array of content items with associated symptoms factors"
      status.should == 200
      JSON.parse(response_body)['contents'].should be_a Array
    end
  end
end
