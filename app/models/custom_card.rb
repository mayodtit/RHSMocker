class CustomCard < ActiveRecord::Base
  belongs_to :content
  has_many :cards, as: :resource

  attr_accessible :content, :title, :raw_preview

  validates :title, :raw_preview, presence: true
end
