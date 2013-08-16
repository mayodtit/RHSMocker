require 'spec_helper'

describe Api::V1::RemoteEventsController do
  let(:valid_attributes) do
    {
      'Events' => [{'name' => 'Test 1', 'createdat' => 123},
                   {'name' => 'Test 2', 'createdat' => 345}],
      'Properties' => {
                        "Device-Language" => "en",
                        "Device-OS" => "iOS",
                        "App-Version" => "0.26-1",
                        "Device-Model" => "Simulator",
                        "Device-Timezone-offset" => -420,
                        "App-Build" => "1",
                        "Device-OS-Version" => "6.1"
                      }
    }
  end

  let(:remote_event) { build_stubbed(:remote_event) }

  describe 'POST create' do
    def do_request
      post :create, valid_attributes
    end

    before(:each) do
      RemoteEvent.stub(:create => remote_event)
    end

    context 'success' do
      it 'returns success' do
        do_request
        response.should be_success
      end
    end

    context' failure' do
      before(:each) do
        # invalidate record to generate an error
        remote_event.data = nil
        remote_event.valid?
      end

      it 'returns failure' do
        do_request
        response.should_not be_success
      end
    end
  end
end
