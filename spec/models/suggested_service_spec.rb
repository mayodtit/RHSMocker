require 'spec_helper'

describe SuggestedService do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :service_template
end
