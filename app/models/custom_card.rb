class CustomCard < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :content
  has_many :cards, as: :resource

  attr_accessible :content, :content_id, :title, :raw_preview

  validates :title, :raw_preview, presence: true
end
