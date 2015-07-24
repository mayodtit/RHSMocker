require 'spec_helper'

describe NewMemberTask do
  it_has_a 'valid factory'
  it_validates 'presence of', :member

  describe 'defaults' do
    let(:pha) { create(:pha) }
    let(:user) { create(:member, :premium, pha: pha) }

    it 'sets the owner' do
      task = create(:new_member_task, member: user, owner: nil)
      expect(task.owner).to eq(pha)
    end

    describe 'due_at' do
      let(:task) { build(:new_member_task, due_at: nil) }

      context 'PHAs are on call' do
        before do
          Timecop.freeze
          Role.stub_chain(:pha, :during_on_call?).and_return(true)
        end

        after do
          Timecop.return
        end

        it 'sets due_at to 6PM today' do
          expect(task.due_at).to be_nil
          task.valid?
          expect(task.due_at).to eq(Time.now.pacific.change(hour: 18))
        end
      end

      context 'PHAs not on call' do
        before do
          Role.stub_chain(:pha, :during_on_call?).and_return(false)
        end

        context 'on the weekend' do
          before do
            Timecop.freeze(Time.parse('2015-07-11 12:00:00 -0700'))
          end

          after do
            Timecop.return
          end

          it 'sets due_at to next weekday at ON_CALL_START_HOUR' do
            expect(task.due_at).to be_nil
            task.valid?
            expect(task.due_at).to eq(Time.parse('2015-07-13 6:00:00 -0700'))
          end
        end

        context 'before midnight' do
          before do
            Timecop.freeze(Time.parse('2015-07-09 23:00:00 -0700'))
          end

          after do
            Timecop.return
          end

          it 'sets due_at to tomorrow before noon' do
            expect(task.due_at).to be_nil
            task.valid?
            expect(task.due_at).to eq(Time.parse('2015-07-10 12:00:00 -0700'))
          end
        end

        context 'after midnight' do
          before do
            Timecop.freeze(Time.parse('2015-07-10 01:00:00 -0700'))
          end

          after do
            Timecop.return
          end

          it 'sets due_at to 6PM today' do
            expect(task.due_at).to be_nil
            task.valid?
            expect(task.due_at).to eq(Time.parse('2015-07-10 18:00:00 -0700'))
          end
        end
      end
    end
  end
end
