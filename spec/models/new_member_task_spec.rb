require 'spec_helper'

describe NewMemberTask do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :member
  end

  describe '#set_due_at' do
    let(:task) { build :new_member_task }

    context 'due_at is present' do
      before do
        task.stub(:due_at) { Time.now }
      end

      it 'does nothing' do
        task.should_not_receive :due_at=
        task.set_due_at
      end
    end

    context 'due_at is not present' do
      before do
        task.due_at = nil
      end

      after do
        Timecop.return
      end

      context 'now is while phas on call' do
        before do
          Timecop.freeze Time.parse('Mon, 30 Jun 2014 8:00:00 PDT -07:00')
        end

        before do
          Role.stub_chain(:pha, :during_on_call?) { true }
        end

        it 'sets due at to end of work day' do
          task.set_due_at
          task.due_at.should == Time.parse('Mon, 30 Jun 2014 18:00:00 PDT -07:00')
        end
      end

      context 'now is not while phas on call' do
        before do
          Role.stub_chain(:pha, :during_on_call?) { false }
        end

        context 'now is sunday' do
          before do
            Timecop.freeze Time.parse('Sun, 29 Jun 2014 8:00:00 PDT -07:00')
          end

          it 'sets due at to beginning of next work day' do
            task.set_due_at
            task.due_at.should == Time.parse("Mon, 30 Jun 2014 0#{ON_CALL_START_HOUR}:00:00 PDT -07:00")
          end
        end

        context 'now is saturday' do
          before do
            Timecop.freeze Time.parse('Sat, 28 Jun 2014 8:00:00 PDT -07:00')
          end

          it 'sets due at to beginning of next work day' do
            task.set_due_at
            task.due_at.should == Time.parse("Mon, 30 Jun 2014 0#{ON_CALL_START_HOUR}:00:00 PDT -07:00")
          end
        end

        context 'now is a weekday' do
          context 'now is past 6pm' do
            before do
              Timecop.freeze Time.parse('Mon, 30 Jun 2014 18:00:00 PDT -07:00')
            end

            it 'sets due at to the middle of the next work day' do
              task.set_due_at
              task.due_at.should == Time.parse('Tues, 31 Jun 2014 12:00:00 PDT -07:00')
            end
          end

          context 'now is before 9am' do
            before do
              Timecop.freeze Time.parse('Mon, 30 Jun 2014 02:00:00 PDT -07:00')
            end

            it 'sets due at to end of the work day' do
              task.set_due_at
              task.due_at.should == Time.parse('Mon, 30 Jun 2014 18:00:00 PDT -07:00')
            end
          end

          context 'now is between 9am and 6pm' do
            before do
              Timecop.freeze Time.parse('Mon, 30 Jun 2014 02:00:00 PDT -07:00')
            end

            it 'sets due at to the end of the work day' do
              task.set_due_at
              task.due_at.should == Time.parse('Mon, 30 Jun 2014 18:00:00 PDT -07:00')
            end
          end
        end
      end
    end
  end
end
