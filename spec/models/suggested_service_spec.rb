require 'spec_helper'

describe SuggestedService do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :suggested_service_template
end
