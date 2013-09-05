require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Factors" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:symptom) { create(:symptom, :patient_type => 'adult') }
  let!(:factor_group) { create(:factor_group, :name => 'pain is', :order => 2) }
  let!(:factor) { create(:factor) }
  let!(:symptoms_factor) { create(:symptoms_factor, :symptom => symptom, :factor_group => factor_group, :factor => factor) }
  let!(:content) { create(:content) }
  let!(:contents_symptoms_factor) { create(:contents_symptoms_factor, :content => content, :symptoms_factor => symptoms_factor) }

  get 'api/v1/factors/:id' do
    parameter :id,      "Symptom id"
    required_parameters :id

    let(:id)   { symptom.id }

    example_request "[GET] Get all the factors for a symptom" do
      explanation "Returns an array of factors available for a symptom"
      status.should == 200
      JSON.parse(response_body)['factor_groups'].should be_a Array
    end
  end

  get 'api/v1/factors/:id' do
    parameter :id,      "Symptom id"
    required_parameters :id

    let(:id)   { 1234 }

    example_request "[GET] Get all the factors for a symptom (404)" do
      explanation "Returns an array of factors available for a symptom"
      status.should == 404
      JSON.parse(response_body)['reason'].should_not be_empty
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
