class Program < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_many :program_resources
  has_many :contents, through: :program_resources, source: :resource, source_type: Content

  attr_accessible :title

  validates :title, presence: true

  def self.general
    find_by_title('General')
  end
end
