require 'spec_helper'

describe DataFieldTemplate do
  it_has_a 'valid factory'
  it_validates 'presence of', :service_template
  it_validates 'presence of', :name
  it_validates 'presence of', :type
  it_validates 'inclusion of', :required_for_service_start
end
