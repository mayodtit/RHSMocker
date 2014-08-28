require 'spec_helper'

describe UpgradeTask do
  it_has_a 'valid factory'
  it_validates 'presence of', :member

  describe '#set_priority' do
    let(:task) { build_stubbed(:upgrade_task) }

    it 'sets it to 9' do
      task.priority = 0
      task.set_priority
      expect(task.priority).to eq(9)
    end
  end
end
