require 'spec_helper'

describe NuxStory do
  it_has_a 'valid factory'
  it_validates 'presence of', :html
  it_validates 'presence of', :action_button_text
  it_validates 'presence of', :unique_id
  it_validates 'inclusion of', :show_nav_signup
  it_validates 'uniqueness of', :unique_id
end
