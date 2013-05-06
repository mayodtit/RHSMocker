
class AuthorsContent < ActiveRecord::Base
  attr_accessible :author_id

  belongs_to :author
  belongs_to :content

end