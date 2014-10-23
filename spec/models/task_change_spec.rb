require 'spec_helper'

describe TaskChange do
  it_has_a 'valid factory'

  describe '#validations' do
    it_validates 'presence of', :task
    it_validates 'presence of', :actor
  end

  context '#serialize_data' do
    let(:test_string) {"this_data"}
    let(:task_change) { build_stubbed(:task_change, data: nil, unserialized_data: test_string) }

    it 'serializes the data before validation' do
      task_change.unserialized_data.should_not be_nil
      task_change.data.should be_nil
      task_change.valid?
      task_change.data.should == test_string.to_s
    end
  end
end
