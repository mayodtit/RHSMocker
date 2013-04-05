require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Factors" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before :all do
    @symptom = FactoryGirl.create(:symptom, :patient_type=>'adult')
    @factor_group = FactoryGirl.create(:factor_group)
    @factor1 = FactoryGirl.create(:factor, :name=>'burning')
    @factor2 = FactoryGirl.create(:factor, :name=>'steady')
    @content = FactoryGirl.create(:content)
    @symptoms_factor1 = FactoryGirl.create(:symptoms_factor, :symptom=>@symptom, :factor_group=>@factor_group, :factor=>@factor1)
    @symptoms_factor2 = FactoryGirl.create(:symptoms_factor, :symptom=>@symptom, :factor_group=>@factor_group, :factor=>@factor2)
    FactoryGirl.create(:contents_symptoms_factor, :content=>@content, :symptoms_factor=>@symptoms_factor1)
    FactoryGirl.create(:contents_symptoms_factor, :content=>@content, :symptoms_factor=>@symptoms_factor2)
  end

  get 'api/v1/factors/:id' do
    parameter :id,      "Symptom id"
    required_parameters :id

    let(:id)   { @symptom.id }
    example_request "[GET] Get all the factors for a symptom" do
      explanation "Returns an array of factors available for a symptom"
      status.should == 200
      JSON.parse(response_body)['factor_groups'].should be_a Hash
    end
  end

  post 'api/v1/symptoms/check' do
    parameter :symptom_id,        "Symptom id"
    parameter :symptoms_factors,  "Collection of symptoms_factor ids"
    required_parameters :symptom_id, :symptoms_factors

    let(:symptom_id)        { @symptom.id }
    let(:symptoms_factors)  { [@symptoms_factor1.id, @symptoms_factor2.id] }
    let(:raw_post)          { params.to_json }  # JSON format request body

    example_request "[POST] Get contents ad associated symptoms factors" do
      explanation "Returns an array of content items with associated symptoms factors"
      status.should == 200
      JSON.parse(response_body)['contents'].should be_a Array
    end
  end

end
