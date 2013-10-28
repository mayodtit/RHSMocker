require 'spec_helper'

class ABaseController < Api::V1::ABaseController
  def index
    render_failure({}, 401)
  end
end

describe ABaseController do
  describe '#render_failure' do
    context 'request from iOS' do
      it 'sets the WWW-Authenticate header for 401' do
        get :index
        response.should_not be_success
        response.status.should == 401
        response.headers['WWW-Authenticate'].should == %(Basic realm="Better")
      end
    end

    context 'request from Web' do
      it 'doesn\'t set the WWW-Authenticate header for 401' do
        request.env['Authorization'] = 'BasicCustom'
        get :index
        response.should_not be_success
        response.status.should == 401
        response.headers['WWW-Authenticate'].should be_nil
      end
    end
  end
end