require 'spec_helper'

describe Factor do
  it_has_a 'valid factory'
  it_validates 'presence of', :name
end
