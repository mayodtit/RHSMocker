class NuxAnswer < ActiveRecord::Base
  attr_accessible :name, :text, :active, :ordinal

  validates :name, :text, :ordinal, presence: true
  validates :active, inclusion: {in: [true, false]}

  scope :active, -> { where(active: true).order('ordinal DESC') }
end
