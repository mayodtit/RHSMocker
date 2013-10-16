require 'spec_helper'

describe UserFeatureGroup do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :feature_group
  it_validates 'scoped uniqueness of', :feature_group_id, :user_id
end
