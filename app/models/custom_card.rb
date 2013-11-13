class CustomCard < ActiveRecord::Base
  belongs_to :content
  has_many :cards, as: :resource

  attr_accessible :content, :title, :body

  validates :title, :body, presence: true
end
