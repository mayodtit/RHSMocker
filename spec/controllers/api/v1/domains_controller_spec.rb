require 'spec_helper'

describe Api::V1::DomainsController do
  
  before do
    Domain.create(email_domain: 'gmail.com')
    Domain.create(email_domain: 'sbcglobal.net')
  end

  describe 'GET index' do

    def do_request(email)
      get(:index, {:email => email})
      JSON.parse(response.body)
    end

  	it 'should return no suggestions for valid email' do
  	  do_request('michael@gmail.com')['suggestion'].should == nil
  	end
  	it 'should return suggestion for 1 edit distance mis-spelled email' do
  	  response = do_request('michael@gmai.com')
  	  response['suggestion']['full'].should == 'michael@gmail.com'
  	end
  	it 'should return suggestion for 2 edit distance mis-spelled email' do
  	  response = do_request('michael@gmei.com')
  	  response['suggestion']['full'].should == 'michael@gmail.com'
  	end
  	it 'should return suggestion for 3 edit distance mis-spelled email' do
  	  response = do_request('michael@sbc123global.net')
  	  response['suggestion']['full'].should == 'michael@sbcglobal.net'
  	end
    it 'michael@getbetter should append the .com at the end' do
      response = do_request('michael@getbetter')
      response['suggestion']['full'].should == 'michael@getbetter.com'
    end
  	it 'should return suggestion when user forgets dot' do
  	  response = do_request('michael@gmaicom')
  	  response['suggestion']['full'].should == 'michael@gmail.com'
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
  	  response['suggestion']['full'].should == 'michael@sbcglobal.net'
  	end
    it 'michaelgmailcom should correct to michael@gmail.com' do
      response = do_request('michaelgmailcom')
      response['suggestion']['full'].should == 'michael@gmail.com'
    end
    it 'michaelgmai1om should correct to michael@gmail.com' do
      response = do_request('michaelgmai1om')
      response['suggestion']['full'].should == 'michael@gmail.com'
    end
  end

  describe 'GET get_all_domains' do
    it 'should return all domains in the database' do
      get(:get_all_domains)
      resp = JSON.parse(response.body)
      resp['domains'][0].should == 'gmail.com'
      resp['domains'].size.should == 2
    end
  end

  describe 'GET submit' do

    def do_request(email)
      get(:submit, {:email => email})
      JSON.parse(response.body)
    end

    it 'should return 422 response if domain is invalid' do
      response = do_request('michael@gmwerrwewe.com')
      response['status_code'].should == 422
    end
    it 'should add domain to db if it does not exist' do
      response = do_request('michael@getbetter.com')
      response['status_code'].should == 200
    end
  end

  describe 'GET suggestions using a prefix' do

    def do_request(email)
      get(:suggest_using_prefix, {:email => email})
      JSON.parse(response.body)
    end

    it 'should return no suggestions since there are no matching entries'  do
      response = do_request('michael@x')
      response['domains'].should == []
    end
    it 'should return suggestion since there are matches in the db' do
      response = do_request('michael@g')
      response['domains'][0].should == 'gmail.com'
    end
  end
end
