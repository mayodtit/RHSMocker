require 'spec_helper'

describe SystemRelativeEventTemplate do
  it_has_a 'valid factory'
  it_validates 'presence of', :root_event_template
end
