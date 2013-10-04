require 'spec_helper'

describe Api::V1::PingController do
  describe 'GET index' do
    def do_request
      get :index
    end

    it_behaves_like 'success'
  end
end
