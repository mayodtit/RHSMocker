require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "SideEffects" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @treatment = create(:treatment)
    @side_effect = create(:side_effect)
    @treatment_side_effect = create(:treatment_side_effect,
                                    :treatment => @treatment,
                                    :side_effect => @side_effect)
    @excluded_side_effect = create(:side_effect, :with_treatment)
  end

  get '/api/v1/side_effects' do
    example_request "[GET] Retrieve all side effects" do
      explanation "Returns an array of side effects"
      status.should == 200
      parsed_json = JSON.parse(response_body)
      parsed_json.should_not be_empty
      parsed_json['side_effects'].map{|x| x['id']}.should include(@side_effect.id, @excluded_side_effect.id)
    end

    context 'with a treatment_id' do
      parameter :treatment_id, "Filter results using treatment_id"
      let(:treatment_id) { @treatment.id }

      example_request "[GET] Retrieve side effects matching treatment id" do
        explanation "Returns an array of side effects filtered by treatment id"
        status.should == 200
        parsed_json = JSON.parse(response_body)
        parsed_json.should_not be_empty
        parsed_json['side_effects'].map{|x| x['id']}.should include(@side_effect.id)
        parsed_json['side_effects'].map{|x| x['id']}.should_not include(@excluded_side_effect.id)
      end
    end

    context 'with a query string' do
      parameter :q, 'Query string'
      let(:q) { @side_effect.name.split(' ')[0] }

      example_request "[GET] Retrieve all side effects matching query string" do
        explanation "Returns an array of side effects matching query string"
        status.should == 200
        parsed_json = JSON.parse(response_body)
        parsed_json.should_not be_empty
        parsed_json['side_effects'].map{|x| x['id']}.should include(@side_effect.id, @excluded_side_effect.id)
      end

      context 'with a treatment_id' do
        parameter :treatment_id, "Filter results using treatment_id"
        let(:treatment_id) { @treatment.id }

        example_request "[GET] Retrieve side effects matching treatment id and query string" do
          explanation "Returns an array of side effects filtered by treatment id that match query string"
          status.should == 200
          parsed_json = JSON.parse(response_body)
          parsed_json.should_not be_empty
          parsed_json['side_effects'].map{|x| x['id']}.should include(@side_effect.id)
          parsed_json['side_effects'].map{|x| x['id']}.should_not include(@excluded_side_effect.id)
        end
      end
    end
  end
end
