require 'spec_helper'

describe SystemAction do
  it_has_a 'valid factory'
  it_validates 'presence of', :system_event
  it_validates 'presence of', :system_action_template
  it_validates 'presence of', :result
end
