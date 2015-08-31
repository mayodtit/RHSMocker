require 'spec_helper'

describe SpecialistMetricsService do
  before do
    Timecop.freeze(Time.parse('2015-09-02 12:00:00 -0700'))
  end

  after do
    Timecop.return
  end

  let!(:specialist) { create(:specialist) }
  let!(:internally_blocked_task_today) { create(:task, :blocked_internal, owner: specialist, blocked_internal_at: Time.now) }
  let!(:externally_blocked_task_today) { create(:task, :blocked_external, owner: specialist, blocked_external_at: Time.now) }
  let!(:internally_blocked_task_yesterday) { create(:task, :blocked_internal, owner: specialist, blocked_internal_at: Time.now.beginning_of_week) }
  let!(:externally_blocked_task_yesterday) { create(:task, :blocked_external, owner: specialist, blocked_external_at: Time.now.beginning_of_week) }

  describe '#call' do

    it 'should return a hash with todays metrics' do
      metrics = described_class.new( specialist ).call
      metrics[:number_of_tasks_completed_today].should eq(0)
      metrics[:number_of_tasks_blocked_internally_today].should eq(1)
      metrics[:number_of_tasks_blocked_externally_today].should eq(1)
    end

    context 'if there was a task completed today' do
      let!(:completed_task) { create(:task, :completed, owner: specialist, claimed_at: Time.now.eight_oclock, completed_at: Time.now.eighteen_oclock) }

      it 'should return the average time of completion for today' do
        metrics = described_class.new( specialist ).call
        metrics[:number_of_tasks_completed_today].should eq(1)
        metrics[:average_time_of_completion_today].should eq(600)
      end
    end

    it 'should return a hash with this weeks metrics' do
      metrics = described_class.new( specialist ).call
      metrics[:number_of_tasks_completed_this_week].should eq(0)
      metrics[:number_of_tasks_blocked_internally_this_week].should eq(2)
      metrics[:number_of_tasks_blocked_externally_this_week].should eq(2)
    end

    context 'if there were tasks completed this week' do
      let!(:completed_task_today) { create(:task, :completed, owner: specialist, claimed_at: Time.now.eight_oclock, completed_at: Time.now.eighteen_oclock) }
      let!(:completed_task_yesterday) { create(:task, :completed, owner: specialist, claimed_at: Time.now.beginning_of_week, completed_at: Time.now.beginning_of_week+10.hours) }
      it 'should return the average time of completion for this week' do
        metrics = described_class.new( specialist ).call
        metrics[:number_of_tasks_completed_this_week].should eq(2)
        metrics[:average_time_of_completion_this_week].should eq(600)
      end
    end
  end
end
