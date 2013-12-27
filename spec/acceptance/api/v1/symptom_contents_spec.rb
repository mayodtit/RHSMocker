require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'SymptomContents' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:factor_content) { create(:factor_content) }
  let(:factor) { factor_content.factor }
  let(:symptom) { factor.symptom }
  let(:content) { factor_content.content }
  let(:symptom_id) { symptom.id }
  let(:factor_ids) { [factor.id] }

  parameter :symptom_id, 'Symptom ID'
  parameter :factor_ids, 'IDs of matching Factors'
  required_parameters :symptom_id

  get '/api/v1/symptoms/:symptom_id/contents' do
    example_request '[GET] Get all contents for a symptom and factors' do
      explanation 'Returns an array of contents for a symptom with optional filtering'
      expect(status).to eq(200)
      json = JSON.parse(response_body, symbolize_names: true)
      expect(json[:contents].to_json).to eq([content].as_json.to_json)
    end
  end
end
