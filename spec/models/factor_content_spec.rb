require 'spec_helper'

describe FactorContent do
  it_has_a 'valid factory'
  it_validates 'presence of', :factor
  it_validates 'presence of', :content
  it_validates 'uniqueness of', :content_id, :factor_id
end
