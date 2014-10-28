class NuxStorySerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :html, :action_button_text, :show_nav_signup
end
