require 'spec_helper'

describe UserPromotion do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :promotion
  it_validates 'uniqueness of', :promotion_id, :user_id
end
