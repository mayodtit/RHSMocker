require 'spec_helper'

describe PhoneCallSummary do
  it_has_a 'valid factory'
  it_validates 'presence of', :caller
  it_validates 'presence of', :callee
  it_validates 'presence of', :body
end
