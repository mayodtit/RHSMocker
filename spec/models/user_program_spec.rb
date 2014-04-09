require 'spec_helper'

describe UserProgram do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :program
  it_validates 'presence of', :subject
end
