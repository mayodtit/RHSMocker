require 'spec_helper'

describe "Errors" do
  shared_examples 'handled error' do |exception, status_code|
    it 'renders json response' do
      HomeController.any_instance.stub(:index).and_raise(exception)
      get root_path
      response.code.to_i.should == status_code
      response.content_type.should == 'application/json'
      body = JSON.parse(response.body)
      body['status'].should == 'failure'
      body['reason'].should == exception.to_s
    end
  end

  describe '404' do
    it_behaves_like 'handled error', ActiveRecord::RecordNotFound, 404
  end

  describe '412' do
    it_behaves_like 'handled error', Error::PreconditionFailed, 412
  end

  describe '500' do
    it_behaves_like 'handled error', Exception, 500
  end
end
