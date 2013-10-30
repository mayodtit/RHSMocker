class Program < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  attr_accessible :title

  validates :title, presence: true
end
