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
end
