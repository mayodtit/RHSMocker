require 'spec_helper'

describe Api::V1::ABaseController do
  describe '#render_failure' do
    controller(Api::V1::ABaseController) do
      skip_before_filter :authentication_check
      def index
        render_failure({reason:"UH OH"}, 401)
      end
    end

    it 'sets the WWW-Authenticate header for 401' do
      get :index
      response.should_not be_success
      response.status.should == 401
      JSON.parse(response.body)['reason'].should == "UH OH"
      response.headers['WWW-Authenticate'].should == %(BasicCustom realm="Better")
    end
  end
end