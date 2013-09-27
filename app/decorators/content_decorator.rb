class ContentDecorator < Draper::Decorator
  delegate_all

  def preview
    body.split(' ').slice(0, 101).join(' ').gsub(/\ADefinition<p>/, "")
  end

  def formatted_body
    if body.scan('</p>').count > 1
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
    '<div class="talk"></div>'
  end
end
