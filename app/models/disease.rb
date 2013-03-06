class Disease < ActiveRecord::Base
  attr_accessible :name
  has_many :user_diseases
  has_and_belongs_to_many :users, :through=> :user_diseases
end
