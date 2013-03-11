class Author < ActiveRecord::Base
  attr_accessible :image_url, :name, :short_name
  has_and_belongs_to_many :contents
end
