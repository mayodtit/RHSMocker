class CustomContent < Content
  private

  def self.max_id
    order('id DESC').first.id
  end

  def set_defaults
    self.document_id = "RHS#{'%05d' % (self.class.max_id + 1)}" if document_id.blank?
    self.raw_body = 'Body for new CustomContent' if raw_body.blank?
    self.content_type = 'Content' if content_type.blank?
    self.show_call_option = true if show_call_option.nil?
    self.show_checker_option = false if show_checker_option.nil?
    self.show_mayo_copyright = false if show_mayo_copyright.nil?
  end
end
