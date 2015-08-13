require 'spec_helper'

describe TaskCategoryExpertise do
  it_has_a 'valid factory'
  it_validates 'presence of', :task_category
  it_validates 'presence of', :expertise
  it_validates 'uniqueness of', :expertise_id, :task_category_id
end
