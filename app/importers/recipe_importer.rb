class RecipeImporter < ContentImporter
  def import
    extract_required_params_from_xml!
    build_html!
    add_intro_to_body!
    add_ingredients_to_body!
    add_directions_to_body!
    create_content!
    create_content_vocabularies!
    :success
  end

  private

  def build_html!
    @html = Nokogiri::HTML::DocumentFragment.parse "<body></body>"
    @body = @html.child
  end

  def add_intro_to_body!
    @body.add_child('<div class="intro">' + CGI.unescapeHTML(@data.at('DietitianTip').text.remove_newlines_and_tabs) + '</div>')
  end

  def add_ingredients_to_body!
    @body.add_child('<div class="ingredients"><h3>Ingredients</h3>' + CGI.unescapeHTML(@data.at('Ingredients').text.remove_newlines_and_tabs) + '</div>')
  end

  def add_directions_to_body!
    @body.add_child('<div class="directions"><h3>Directions</h3>' + CGI.unescapeHTML(@data.at('Directions').text.remove_newlines_and_tabs) + '</div>')
  end

  def body
    @html.to_html
  end
end
