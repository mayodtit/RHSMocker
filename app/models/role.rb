class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true

  attr_accessible :name, :resource, :resource_id, :resource_type

  validates :name, presence: true,
                   uniqueness: {scope: %i(resource_id resource_type)}
end
