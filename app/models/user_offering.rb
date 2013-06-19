class UserOffering < ActiveRecord::Base
  belongs_to :offering
  belongs_to :user
  # attr_accessible :title, :body
end
