require 'spec_helper'

describe UpgradeTask do
  it_has_a 'valid factory'
  it_validates 'presence of', :member

  its 'default priority gets set on create' do
    task = build(:upgrade_task)
    task.valid?
    expect(task.priority).to eq(6)
  end
end
