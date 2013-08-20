require 'spec_helper'

describe ConsultUser do
  it_has_a 'valid factory'

  it_validates 'presence of', :consult
  it_validates 'presence of', :user
  it_validates 'scoped uniqueness of', :user_id, :consult_id
end
