class NuxStory < ActiveRecord::Base
  attr_accessible :html, :action_button_text, :show_nav_signup

  validates :html, :action_button_text, presence: true
  validates :show_nav_signup, inclusion: {in: [true, false]}
end
