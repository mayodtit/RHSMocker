require 'spec_helper'

describe Api::V1::ValidateEmailController do
  def do_request(email)
  	get(:index, {:q => email})
  	JSON.parse(response.body)
  end
  describe 'GET index' do
  	it 'should return no suggestions for valid email' do
  	  do_request('michael@gmail.com')['suggestion'].should == false
  	end
  	it 'should return suggestion for 1 edit distance mis-spelled email' do
  	  response = do_request('michael@gmai.com')
  	  response['suggestion'].should == true
  	  response['full'].should == 'michael@gmail.com'
  	end
  	it 'should return suggestion for 2 edit distance mis-spelled email' do
  	  response = do_request('michael@gmei.com')
  	  response['suggestion'].should == true
  	  response['full'].should == 'michael@gmail.com'
  	end
  	it 'should return suggestion for 3 edit distance mis-spelled email' do
  	  response = do_request('michael@sbc123global.net')
  	  response['suggestion'].should == true
  	  response['full'].should == 'michael@sbcglobal.net'
  	end
  	it 'should return suggestion when user forgets dot' do
  	  response = do_request('michael@gmaicom')
  	  response['suggestion'].should == true
  	  response['full'].should == 'michael@gmail.com'
  	end
  	it 'should return no suggestion for obscure email domains' do
  	  do_request('michael@getbetter.com')['suggestion'].should == false
  	end
  	it 'should return 422 response because of invalid email domain' do
  	  do_request('michael@asdfqw3f.com')['status_code'].should == 422
  	end
  	it 'should return 422 response because of invalid email domain as well as suggestion' do
  	  response = do_request('michael@sb12cglobal.net')
  	  response['status_code'].should == 422
  	  response['suggestion'].should == true
  	  response['full'].should == 'michael@sbcglobal.net'
  	end
    it 'michaelgmailcom should correct to michael@gmail.com' do
      response = do_request('michaelgmailcom')
      response['suggestion'].should == true
      response['full'].should == 'michael@gmail.com'
    end
    it 'michaelgmai1om should correct to michael@gmail.com' do
      response = do_request('michaelgmai1om')
      response['suggestion'].should == true
      response['full'].should == 'michael@gmail.com'
    end
  end
end
