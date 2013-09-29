class ContentDecorator < Draper::Decorator
  delegate_all

  # card preview, first 100 words and strip out Definition header
  def preview
    body.split(' ').slice(0, 101).join(' ').gsub(/\ADefinition<p>/, "")
  end

  # insert the "would you like to talk to someone" text
  def formatted_body
    if !show_call_option?
      body
    elsif body.scan('</p>').count > 1
      body.insert(body.index(/<\/p>/, body.index(/<\/p>/) + 4) + 4, talk)
    elsif body.scan('</p>').count == 1
      body.insert(body.index(/<\/p>/) + 4, talk)
    elsif body.index(/<\/body>/)
      body.insert(body.index(/<\/body>/) + 6, talk)
    else
      body
    end
  end

  private

  def talk
    "<div class=\"talk\" data-content-id=#{id} data-message=\"#{talk_message}\"></div>"
  end

  def talk_message
    "I was reading the article #{title} and would like to discuss it with a Personal Health Assistant."
  end
end
