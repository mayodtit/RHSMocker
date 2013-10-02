class ContentDecorator < Draper::Decorator
  delegate_all

  # card preview, first 100 words and strip out Definition header
  def preview
    body.split(' ').slice(0, 101).join(' ').gsub(/\ADefinition<p>/, "")
  end

  # insert the "would you like to talk to someone" text
  def formatted_body
    if show_call_option?
      insert_talk_button
    else
      body
    end
  end

  private

  def insert_talk_button
    body.insert(body_tag_position, talk)
    return body
  end

  def paragraph_tag_count
    body.scan('</p>').count
  end

  def paragraph_tag_position
    body.index(/<\/p>/) + 4
  end

  def second_paragraph_tag_position
    body.index(/<\/p>/, paragraph_tag_position) + 4
  end

  def body_tag_present?
    body.index(/<\/body>/)
  end

  def body_tag_position
    body.index(/<\/body>/)
  end

  def talk
    "<div class=\"talk\" data-content-id=#{id} data-message=\"#{talk_message}\"></div>"
  end

  def talk_message
    "I was reading the article #{title} and would like to discuss it with a Personal Health Assistant."
  end
end
