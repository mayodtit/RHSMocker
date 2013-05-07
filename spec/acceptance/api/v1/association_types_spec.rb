require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "AssociationTypes" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before(:all) do
    @user = FactoryGirl.create(:user_with_email)
    @user.login
    FactoryGirl.create(:association_type)
  end



  get '/api/v1/association_types' do

    example_request "[GET] Get all association_types" do
      explanation "Returns an array of association_types"

      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end

end
