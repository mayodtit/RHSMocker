class Role < ActiveRecord::Base
  has_many :user_roles
  has_many :users, through: :user_roles
  belongs_to :resource, polymorphic: true

  attr_accessible :name, :resource, :resource_id, :resource_type

  validates :name, presence: true,
                   uniqueness: {scope: %i(resource_id resource_type)}
end
