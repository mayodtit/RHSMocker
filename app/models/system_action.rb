class SystemAction < ActiveRecord::Base
  belongs_to :system_event, inverse_of: :system_action
  belongs_to :system_action_template, inverse_of: :system_actions
  belongs_to :result, polymorphic: true

  attr_accessible :system_event, :system_action_template, :result

  validates :system_event, :system_action_template, :result, presence: true
end
