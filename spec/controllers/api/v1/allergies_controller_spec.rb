require 'spec_helper'

describe Api::V1::AllergiesController do
  describe 'GET index' do
    before :each do
      Allergy.destroy_all # TODO: workaround for dirty test DB
      FactoryGirl.create(:allergy)
      @a = FactoryGirl.create(:allergy, snomed_code: '160244002')
    end

    context 'without parameter' do
      it 'should exclude "No Known Allergies" from search results' do
        get :index
        assigns(:allergies).should_not include(@a)
        assigns(:allergies).count.should == 1
      end
    end

    context 'with parameter' do
      it 'should exclude "No Known Allergies" from search results' do
        described_class.any_instance.stub(:solr_results).and_return(Allergy.all)

        get :index, q: 'foo'

        assigns(:allergies).should_not include(@a)
        assigns(:allergies).count.should == 1
      end
    end
  end
end