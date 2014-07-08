require 'spec_helper'

describe MemberStateTransition do
  it_has_a 'valid factory'
  it_validates 'presence of', :member
end
