require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'FactorGroups' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:factor_group) { create(:factor_group) }
  let(:symptom) { factor_group.symptom }
  let(:symptom_id) { symptom.id }

  parameter :symptom_id, 'Symptom ID'
  required_parameters :symptom_id

  get '/api/v1/symptoms/:symptom_id/factor_groups' do
    example_request '[GET] Get all factor_groups and factors for a symptom' do
      explanation 'Returns an array of factor_groups for a symptom'
      expect(status).to eq(200)
      json = JSON.parse(response_body, symbolize_names: true)
      expect(json[:factor_groups].to_json).to eq([factor_group].serializer.to_json)
    end
  end
end
