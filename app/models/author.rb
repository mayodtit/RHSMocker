class Author < ActiveRecord::Base
  attr_accessible :imageURL, :name, :shortName
  has_and_belongs_to_many :contents
end
