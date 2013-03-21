class Disease < ActiveRecord::Base
  attr_accessible :name
  has_many :user_diseases
  has_many :users, :through=> :user_diseases

  searchable do
    text :name
  end
end
