require 'spec_helper'

describe Permission do
  it_has_a 'valid factory'
  it_validates 'presence of', :user
  it_validates 'presence of', :subject
  it_validates 'presence of', :name
  it_validates 'presence of', :level
  it_validates 'uniqueness of', :name, :subject_id
  it 'validates basic_info is view or edit' do
    permission = build_stubbed(:permission, name: :basic_info, level: :none)
    expect(permission).to_not be_valid
    expect(permission.errors[:level]).to include('must be at least view for basic_info')
  end
end
