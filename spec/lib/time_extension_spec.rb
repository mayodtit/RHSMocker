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

  describe '#business_minutes_from' do
    # Friday
    let(:t) { Time.parse '2014-06-13 02:00:00 -0700' }

    context 'scheduled during business hours' do
      it 'returns the time plus the minutes arguement' do
        t.business_minutes_from(600).should == Time.parse('2014-06-13 12:00:00 -0700')
      end
    end

    context 'scheduled not during business hours' do
      it 'returns the next business time ' do
        t.business_minutes_from(1440).should == Time.parse('2014-06-16 06:00:00 -0700')
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
          time.next_business_day_in_words.should == 'Monday'
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
          time.next_business_day_in_words.should == 'later today'
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
          time.next_business_day_in_words(ActiveSupport::TimeZone.new('America/New_York')).should == 'Monday'
        end
      end

      context 'next business day is today, but hasn\'t started yet' do
        let(:time) { Time.parse("December 23, 2010 22:00 PST -08:00") }

        it 'returns now' do
          time.next_business_day_in_words(ActiveSupport::TimeZone.new('America/Denver')).should == 'tomorrow'
        end
      end

      context 'next business day is today, but hasn\'t started yet' do
        let(:time) { Time.parse("December 23, 2010 23:00 HAST -10:00") }

        # Breaking on semaphore
        xit 'returns now' do
          time.next_business_day_in_words(ActiveSupport::TimeZone.new('Pacific/Hawaii')).should == 'tomorrow'
        end
      end

      context 'next business day is tomorrow, but today in current time zone' do
        let(:time) { Time.parse("December 23, 2010 22:00 PST -08:00") }

        it 'returns now' do
          time.next_business_day_in_words(ActiveSupport::TimeZone.new('America/New_York')).should == 'later today'
        end
      end

      context 'next business day is tomorrow' do
        let(:time) { Time.parse("December 23, 2010 01:00 EST -08:00") }

        it 'returns now' do
          time.next_business_day_in_words(ActiveSupport::TimeZone.new('America/New_York')).should == 'later today'
        end
      end
    end
  end

  describe '#is_business_time?' do
    it 'returns true when time is on workday and during business hours' do
      t = Time.parse("October 31st, 2014, 3:00pm PDT")
      t.should be_business_time
    end

    it 'returns false when time is not on workday' do
      t = Time.parse("November 1st, 2014, 3:00pm PDT")
      t.should_not be_business_time
    end

    it 'returns false when time is before start of business hours' do
      t = Time.parse("October 31st, 2014, 5:00am PDT")
      t.should_not be_business_time
    end

    it 'returns false when time is after end of business hours' do
      t = Time.parse("October 31st, 2014, 9:01pm PDT")
      t.should_not be_business_time
    end
  end
end
