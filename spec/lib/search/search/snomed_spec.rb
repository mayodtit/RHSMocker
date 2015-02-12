require 'rspec'
require 'spec_helper'

describe Search::Service::Snomed do

  def snomed
    @snomed ||= Search::Service::Snomed.new
  end

  describe '#select_query' do
    before do
      @params = {:q => ''}
    end

    context 'allergies' do
      it 'should return allergy query string' do
        query = snomed.send(:select_query, true, @params)
        query.should == 'query=%20allergy&searchMode=partialMatching&lang=english&statusFilter=activeOnly&skipTo=&returnLimit=100&semanticFilter=disorder&normalize=true'
      end
    end

    context 'conditions' do
      it 'should return condition query string' do
        query = snomed.send(:select_query, false, @params)
        query.should == 'query=&searchMode=partialMatching&lang=english&statusFilter=activeOnly&skipTo=&returnLimit=100&normalize=true'
      end
    end
  end

  describe '#allergy_query' do
    before do
      @params = {q: 'filler text'}
    end
    it 'should construct generic allergy query with given params' do
      query = snomed.send(:allergy_query, @params)
      query.should == 'query=filler%20text%20allergy&searchMode=partialMatching&lang=english&statusFilter=activeOnly&skipTo=&returnLimit=100&semanticFilter=disorder&normalize=true'
    end
  end

  describe '#condition_query' do
    before do
      @params = {q: 'filler text'}
    end
    it 'should construct generic condition query with given params' do
      query = snomed.send(:condition_query, @params)
      query.should == 'query=filler%20text&searchMode=partialMatching&lang=english&statusFilter=activeOnly&skipTo=&returnLimit=100&normalize=true'
    end
  end

  before do
    @response = {
        'matches' => [{
        'term'=> 'Brain tumor',
        'conceptId'=> '254935002',
        'descriptionId' => '379840013',
        'fsn' => 'Intracranial tumor (disorder)', }]
    }
  end

  describe '#sanitize_response' do
    context 'allergy response' do
      it 'should select sanitize_allergy method' do
        result = snomed.send(:sanitize_response, true, @response)
        result[0][:food_allergen].should == false
      end
    end
    context 'condition response' do
      it 'should select sanitize_condition method' do
        result = snomed.send(:sanitize_response, false, @response)
        result[0][:food_allergen].should == nil
      end
    end
  end

  describe '#set_result' do
    it 'sets the current_result to better api format from a match given by snomed' do
      result = snomed.send(:set_result, Hash.new, @response)
      result[:name].should == @response['term']
      result[:smomed_name].should == @response['term']
      result[:snomed_code].should == @response['concept_id']
      result[:description_id].should == @response['description']
      result[:concept_id].should == @response['concept_id']
    end
  end

  describe '#condition_filter' do
    it 'filters condition terms' do
      snomed.send(:condition_filter, 'Cancer of the brain (disorder)').should == true
      snomed.send(:condition_filter, 'Cat allergy').should == true
      snomed.send(:condition_filter, 'CA - Brain').should == true
      snomed.send(:condition_filter, 'Brain tumor').should == false
    end
  end

  describe '#allergy_filter' do
    it 'filters allergy terms' do
      snomed.send(:allergy_filter, 'Brain allergy (disorder)').should == true
      snomed.send(:allergy_filter, 'Cat allergy').should == false
    end
  end
end
