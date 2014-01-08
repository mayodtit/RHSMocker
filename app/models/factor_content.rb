class FactorContent < ActiveRecord::Base
  belongs_to :factor
  belongs_to :content

  attr_accessible :factor, :factor_id, :content, :content_id

  validates :factor, :content, presence: :true
  validates :content_id, uniqueness: {scope: :factor_id}
end
