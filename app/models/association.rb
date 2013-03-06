class Association < ActiveRecord::Base
  belongs_to :user
  belongs_to :associate
  attr_accessible :relation, :relation_type
end
