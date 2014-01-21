class CustomCard < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :content
  has_many :cards, as: :resource
  serialize :card_actions, Array
  serialize :timeline_action, Hash

  attr_accessible :content, :content_id, :title, :raw_preview, :card_actions,
                  :timeline_actions, :priority, :unique_id

  validates :title, :raw_preview, presence: true
  validates :unique_id, uniqueness: true, allow_blank: true

  before_validation :set_defaults, on: :create

  private

  def set_defaults
    self.raw_preview = 'New card text for CustomCard' if raw_preview.blank?
  end
end
