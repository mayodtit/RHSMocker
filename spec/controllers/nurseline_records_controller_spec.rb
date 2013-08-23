require 'spec_helper'

describe NurselineRecordsController do
  describe 'POST create' do
    context 'with a body' do
      def do_request
        post :create, :data => :test
      end

      it_behaves_like 'success'
    end

    context 'with no body' do
      def do_request
        post :create
      end

      it_behaves_like 'failure'
    end
  end
end
