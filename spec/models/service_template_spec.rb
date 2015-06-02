require 'spec_helper'

describe ServiceTemplate do
  it_has_a 'valid factory'
  it_validates 'presence of', :name
  it_validates 'presence of', :title
  it_validates 'presence of', :service_type
  it_validates 'inclusion of', :user_facing

  describe '#calculated_due_at' do
    before do
      Timecop.freeze(Time.parse('2015-06-02 09:00:00 -0700'))
    end

    after do
      Timecop.return
    end

    let(:service_template) { described_class.new(time_estimate: 1) }

    it 'calcuates due_at in relative business minutes' do
      expect(service_template.calculated_due_at).to eq(Time.parse('2015-06-02 09:01:00 -0700'))
    end
  end
end
