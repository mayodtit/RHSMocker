class CustomContent < Content
  private

  def set_defaults
    self.show_call_option = true if show_call_option.nil?
    self.show_checker_option = false if show_checker_option.nil?
    self.show_mayo_copyright = false if show_mayo_copyright.nil?
  end
end
