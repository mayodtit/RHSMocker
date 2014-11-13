class NuxStoryChange < ActiveRecord::Base
  belongs_to :nux_story
  serialize :data, Hash

  attr_accessible :nux_story, :nux_story_id, :data

  validates :nux_story, presence: true
end
