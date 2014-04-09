class Program < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  has_many :program_resources
  has_many :contents, through: :program_resources,
                      source: :resource,
                      source_type: Content
  has_many :user_programs, dependent: :destroy
  has_many :users, through: :user_programs

  attr_accessible :title

  validates :title, presence: true

  def self.general
    find_by_title('General')
  end
end
