require 'spec_helper'

describe ContentReference do
  it_has_a 'valid factory'
  it_validates 'presence of', :referrer
  it_validates 'presence of', :referee
  it_validates 'uniqueness of', :referee_id, :referrer_id
end
