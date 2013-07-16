require 'spec_helper'

describe RemoteEvent do
  it_has_a 'valid factory'
  it_validates 'presence of', :data
end
