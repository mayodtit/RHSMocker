class Expertise < ActiveRecord::Base
  has_many :user_expertises
  has_many :users, through: :user_expertises
  belongs_to :resource, polymorphic: true

  attr_accessible :name, :resource, :resource_id, :resource_type

  validates :name, presence: true,
                   uniqueness: {scope: %i(resource_id resource_type)}
end
