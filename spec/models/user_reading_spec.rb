require 'spec_helper'

describe UserReading do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :content
  it_validates 'presence of', :view_count
  it_validates 'presence of', :save_count
  it_validates 'presence of', :dismiss_count
  it_validates 'presence of', :share_count
end
