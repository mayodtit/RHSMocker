require 'spec_helper'

describe Program do
  it_has_a 'valid factory'
  it_validates 'presence of', :title
end
