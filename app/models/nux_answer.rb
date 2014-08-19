class NuxAnswer < ActiveRecord::Base
  attr_accessible :name, :text, :active, :ordinal, :phrase

  validates :name, :text, :ordinal, :phrase, presence: true
  validates :active, inclusion: {in: [true, false]}

  scope :active, -> { where(active: true).order('ordinal DESC') }
end
