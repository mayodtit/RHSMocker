require 'spec_helper'

describe Api::V1::ABaseController do
  describe '#render_failure' do
    it 'sets the WWW-Authenticate header for 401' do
      get :render_failure
      response.should_not be_success
      response.status.should == 401
      response.headers['WWW-Authenticate'].should == %(BasicCustom realm="Better")
    end
  end
end
