require 'spec_helper'

describe Content do
  it_has_a 'valid factory'
  it_validates 'presence of', :title
  it_validates 'presence of', :body
  it_validates 'presence of', :content_type
  it_validates 'presence of', :document_id
  it_validates 'inclusion of', :show_call_option
  it_validates 'inclusion of', :show_checker_option
  it_validates 'inclusion of', :show_mayo_copyright
  it_validates 'uniqueness of', :document_id
end
