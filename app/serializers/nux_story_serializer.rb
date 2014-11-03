class NuxStorySerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :html, :action_button_text, :show_nav_signup, :unique_id,
             :enable_webview_scrolling, :text_header, :text_footer
end
