require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "AgreementPages" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let!(:user_agreement) { create(:agreement_page, :page_type => :user_agreement) }
  let!(:privacy_policy) { create(:agreement_page, :page_type => :privacy_policy) }

  get '/api/v1/agreement_pages' do
    example_request "[GET] Get all agreement pages" do
      explanation "Returns an array of agreement pages"
      status.should == 200
      JSON.parse(response_body).should_not be_empty
    end
  end
end
