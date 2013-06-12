require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "SideEffects" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:treatment) { create(:treatment) }
  let!(:side_effect) { create(:side_effect) }
  let!(:treatment_side_effect) { create(:treatment_side_effect,
                                        :treatment => treatment,
                                        :side_effect => side_effect) }
  let!(:excluded_side_effect) { create(:side_effect, :with_treatment) }

  get '/api/v1/side_effects' do
    example_request "[GET] Retrieve all side effects" do
      explanation "Returns an array of side effects"
      status.should == 200
      parsed_json = JSON.parse(response_body)
      parsed_json.should_not be_empty
      parsed_json['side_effects'].map{|x| x['id']}.should include(side_effect.id, excluded_side_effect.id)
    end

    parameter :treatment_id, "Filter results using treatment_id"

    let(:treatment_id) { treatment.id }

    example_request "[GET] Retrieve side effects matching treatment id" do
      explanation "Returns an array of side effects filtered by treatment id"
      status.should == 200
      parsed_json = JSON.parse(response_body)
      parsed_json.should_not be_empty
      parsed_json['side_effects'].map{|x| x['id']}.should include(side_effect.id)
      parsed_json['side_effects'].map{|x| x['id']}.should_not include(excluded_side_effect.id)
    end
  end
end
