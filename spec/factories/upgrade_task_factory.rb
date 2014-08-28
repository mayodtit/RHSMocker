FactoryGirl.define do
  factory :upgrade_task, class: UpgradeTask, parent: :task do
    member
    title 'Member upgraded!'
  end
end
