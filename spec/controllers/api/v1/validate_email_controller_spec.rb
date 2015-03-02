require 'spec_helper'

describe Api::V1::ValidateEmailController do
  def do_request(email)
  	get(:index, {:email => email})
  	JSON.parse(response.body)
  end
  describe 'GET index' do
  	it 'should return no suggestions for valid email' do
  	  do_request('michael@gmail.com')['suggestion'].should == nil
  	end
  	it 'should return suggestion for 1 edit distance mis-spelled email' do
  	  response = do_request('michael@gmai.com')
  	  response['suggestions']['full'].should == 'michael@gmail.com'
  	end
  	it 'should return suggestion for 2 edit distance mis-spelled email' do
  	  response = do_request('michael@gmei.com')
  	  response['suggestions']['full'].should == 'michael@gmail.com'
  	end
  	it 'should return suggestion for 3 edit distance mis-spelled email' do
  	  response = do_request('michael@sbc123global.net')
  	  response['suggestions']['full'].should == 'michael@sbcglobal.net'
  	end
  	it 'should return suggestion when user forgets dot' do
  	  response = do_request('michael@gmaicom')
  	  response['suggestions']['full'].should == 'michael@gmail.com'
  	end
  	it 'should return no suggestion for obscure email domains' do
  	  do_request('michael@getbetter.com')['suggestion'].should == nil
  	end
  	it 'should return 422 response because of invalid email domain' do
  	  do_request('michael@asdfqw3f.com')['status_code'].should == 422
  	end
  	it 'should return 422 response because of invalid email domain as well as suggestion' do
  	  response = do_request('michael@sb12cglobal.net')
  	  response['status_code'].should == 422
  	  response['suggestions']['full'].should == 'michael@sbcglobal.net'
  	end
    it 'michaelgmailcom should correct to michael@gmail.com' do
      response = do_request('michaelgmailcom')
      response['suggestions']['full'].should == 'michael@gmail.com'
    end
    it 'michaelgmai1om should correct to michael@gmail.com' do
      response = do_request('michaelgmai1om')
      response['suggestions']['full'].should == 'michael@gmail.com'
    end
  end
end
