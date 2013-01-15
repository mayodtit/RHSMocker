class Author < ActiveRecord::Base
  attr_accessible :imageURL, :name, :shortName
  has_many :contents
end
