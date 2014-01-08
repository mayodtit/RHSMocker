require 'spec_helper'

describe WaitlistEntry do
  it_has_a 'valid factory'
  it_validates 'presence of', :email
  it_validates 'uniqueness of', :email
end
