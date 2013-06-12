require 'spec_helper'

describe Object do
  let(:object) { Object.new }

  describe '#try_method' do
    context 'method does not exist' do
      let(:method) { :blah? }

      before(:each) do
        object.should_not respond_to(method)
      end

      it 'returns nil' do
        object.try_method(method).should be_nil
      end
    end

    context 'method exists' do
      let(:method) { :nil? }
      let(:return_value) { double('return') }

      before(:each) do
        object.should respond_to(method)
      end

      it 'calls the method' do
        object.should_receive(method)
        object.try_method(method)
      end

      it "returns the method's result" do
        object.stub(method => return_value)
        object.try_method(method).should == return_value
      end
    end
  end
end
