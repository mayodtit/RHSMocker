require 'spec_helper'

describe ServiceTemplate do
  it_has_a 'valid factory'

  describe 'validations' do
    it_validates 'presence of', :name
    it_validates 'presence of', :title
    it_validates 'presence of', :service_type
    it_validates 'inclusion of', :user_facing
    it_validates 'presence of', :version
    it_validates 'presence of', :state
    it_validates 'uniqueness of', :state, :unique_id
    it_validates 'uniqueness of', :version, :unique_id
  end

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

  describe '#create_deep_copy!' do
    let(:service_template) { build_stubbed(:service_template)}

    it 'creates a deep copy of the current service template' do
      service_template.should_receive(:create_deep_copy!) { service_template }

      service_template.create_deep_copy!.should == service_template
    end
  end
end
