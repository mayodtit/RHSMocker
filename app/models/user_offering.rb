class UserOffering < ActiveRecord::Base
  belongs_to :offering
  belongs_to :user
  belongs_to :phone_call
  # attr_accessible :title, :body
end
