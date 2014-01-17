class QuestionSerializer < ViewSerializer
  self.root = false

  attributes :title

  delegate :title, :view, to: :object

  def body
    controller.render_to_string(template: 'api/v1/questions/show',
                                layout: 'serializable',
                                formats: :html,
                                locals: {card: nil, question: self})
  end

  def raw_body
    controller.render_to_string(template: 'api/v1/questions/show',
                                formats: :html,
                                locals: {card: nil, question: self})
  end
  alias_method :raw_preview, :raw_body

  def preview
    controller.render_to_string(template: 'api/v1/cards/preview',
                                layout: 'serializable',
                                formats: :html,
                                locals: {card: nil, resource: self, current_user: scope})
  end

  def content_type
    'Question'
  end
  alias_method :content_type_display, :content_type

  def share_url
    nil
  end

  def card_actions
    if object.view == :diet
      [
        {normal: {title: 'Save', action: :save}}
      ]
    else
      [
        {normal: {title: 'Dismiss', action: :dismiss}},
        {normal: {title: 'Answer Later', action: :save}}
      ]
    end
  end

  def fullscreen_actions
    []
  end

  def timeline_action
    {}
  end
end
