class Author < ActiveRecord::Base
  attr_accessible :image_url, :name, :short_name
  has_many :authors_contents
  has_many :contents, :through=>:authors_contents
end
