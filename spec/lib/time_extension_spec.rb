require 'spec_helper'

describe TimeExtension do
  describe '#next_wday' do
    # Tuesday
    let(:t) { Time.parse '2014-06-10 02:00:00' }
    before do
      t.wday.should == 2
    end

    context 'wday is greater than the time\'s wday' do
      it 'returns a time during the week' do
        t.next_wday(4).should == Time.parse('2014-06-12 02:00:00')
      end
    end

    context 'wday is equal to time\'s wday' do
      it 'returns a time next week' do
        t.next_wday(2).should == Time.parse('2014-06-17 02:00:00')
      end
    end

    context 'wday is less than the time\'s wday' do
      it 'returns a time next week' do
        t.next_wday(0).should == Time.parse('2014-06-15 02:00:00')
        t.next_wday(1).should == Time.parse('2014-06-16 02:00:00')
      end
    end
  end
end