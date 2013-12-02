require 'spec_helper'

describe ProgramResource do
  it_has_a 'valid factory'
  it_validates 'presence of', :program
  it_validates 'presence of', :resource
  it_validates 'presence of', :ordinal
  it_validates 'uniqueness of', :resource_id, :program_id, :resource_type
end
