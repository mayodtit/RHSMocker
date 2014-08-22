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

  describe '#next_business_day_in_words' do
    context 'in pacific time zone' do
      context 'during business day' do
        let(:time) { Time.parse("December 23, 2010 15:00 PST -08:00") }

        it 'returns now' do
          time.next_business_day_in_words.should == 'now'
        end
      end

      context 'next business day is a few days away' do
        let(:time) { Time.parse("December 24, 2010 21:00 PST -08:00") }

        it 'returns now' do
          time.next_business_day_in_words.should == 'monday'
        end
      end

      context 'next business day is today, but hasn\'t started yet' do
        let(:time) { Time.parse("December 23, 2010 21:00 PST -08:00") }

        it 'returns now' do
          time.next_business_day_in_words.should == 'tomorrow'
        end
      end

      context 'next business day is tomorrow' do
        let(:time) { Time.parse("December 23, 2010 01:00 PST -08:00") }

        it 'returns now' do
          time.next_business_day_in_words.should == 'today at 9AM'
        end
      end
    end

    context 'in different time zone' do
      context 'during business day' do
        let(:time) { Time.parse("December 23, 2010 15:00 PST -08:00") }

        it 'returns now' do
          time.next_business_day_in_words(ActiveSupport::TimeZone.new('America/New_York')).should == 'now'
        end
      end

      context 'next business day is a few days away' do
        let(:time) { Time.parse("December 24, 2010 21:00 PST -08:00") }

        it 'returns now' do
          time.next_business_day_in_words(ActiveSupport::TimeZone.new('America/New_York')).should == 'monday'
        end
      end

      context 'next business day is today, but hasn\'t started yet' do
        let(:time) { Time.parse("December 23, 2010 20:00 PST -08:00") }

        it 'returns now' do
          time.next_business_day_in_words(ActiveSupport::TimeZone.new('America/New_York')).should == 'tomorrow'
        end
      end

      context 'next business day is today, but hasn\'t started yet' do
        let(:time) { Time.parse("December 23, 2010 23:00 HAST -10:00") }

        it 'returns now' do
          time.next_business_day_in_words(ActiveSupport::TimeZone.new('America/Hawaii')).should == 'tomorrow'
        end
      end

      context 'next business day is tomorrow, but today in current time zone' do
        let(:time) { Time.parse("December 23, 2010 22:00 PST -08:00") }

        it 'returns now' do
          time.next_business_day_in_words(ActiveSupport::TimeZone.new('America/New_York')).should == 'today at 12PM'
        end
      end

      context 'next business day is tomorrow' do
        let(:time) { Time.parse("December 23, 2010 01:00 EST -08:00") }

        it 'returns now' do
          time.next_business_day_in_words(ActiveSupport::TimeZone.new('America/New_York')).should == 'today at 12PM'
        end
      end
    end
  end
end