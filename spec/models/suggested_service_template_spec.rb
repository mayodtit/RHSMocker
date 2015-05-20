require 'spec_helper'

describe SuggestedServiceTemplate do
  it_has_a 'valid factory'
  it_validates 'presence of', :title
  it_validates 'presence of', :description
  it_validates 'presence of', :message
  it_validates 'foreign key of', :service_template
end
