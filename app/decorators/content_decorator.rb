class ContentDecorator < Draper::Decorator
  delegate_all

  # card preview, first 100 words and strip out Definition header
  def preview
    body.split(' ').slice(0, 101).join(' ').gsub(/\ADefinition<p>/, "")
  end
end
