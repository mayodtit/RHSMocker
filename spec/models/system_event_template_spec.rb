require 'spec_helper'

describe SystemEventTemplate do
  it_has_a 'valid factory'
  it_has_a 'valid factory', :with_system_action_template
  it_validates 'presence of', :title
end
