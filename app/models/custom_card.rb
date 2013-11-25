class CustomCard < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :content
  has_many :cards, as: :resource

  attr_accessible :content, :content_id, :title, :raw_preview

  validates :title, :raw_preview, presence: true

  before_validation :set_defaults, on: :create

  private

  def set_defaults
    self.raw_preview = 'New card text for CustomCard' if raw_preview.blank?
  end
end
