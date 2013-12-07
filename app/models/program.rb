class Program < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_many :program_resources

  attr_accessible :title

  validates :title, presence: true
end
