class CardSerializer < ViewSerializer
  self.root = false

  attributes :id, :user_id, :resource_id, :resource_type, :state, :created_at, :updated_at,
             :priority, :state_changed_at, :title, :content_type, :content_type_display,
             :share_url, :actions, :card_actions, :fullscreen_actions, :timeline_action,
             :size

  def attributes
    super.merge!(state_specific_date)
  end

  def resource_type
    if object.resource_type == 'CustomCard'
      'Content'
    else
      object.resource_type
    end
  end

  delegate :title, :content_type, :content_type_display, :share_url,
           :raw_body, :raw_preview, :card_actions, :fullscreen_actions, to: :resource

  def body
    controller.render_to_string(template: 'api/v1/cards/show',
                                layout: 'serializable',
                                formats: :html,
                                locals: {card: object, resource: resource, current_user: scope})
  end

  def preview
    controller.render_to_string(template: 'api/v1/cards/preview',
                                layout: 'serializable',
                                formats: :html,
                                locals: {card: object, resource: resource, current_user: scope})
  end

  def actions
    card_actions
  end

  def timeline_action
    if %w(Consult CustomCard).include?(object.resource_type)
      resource.timeline_action
    elsif %w(Question).include?(object.resource_type)
      resource.timeline_action.tap do |action|
        if action[:action] == 'editProfile'
          action[:arguments].merge!(card_id: object.id, id: object.user_id)
        end
      end
    else
      {
        action: 'openCard',
        arguments: {id: object.id}
      }
    end
  end

  def size
    if resource.is_a?(ContentSerializer) && resource.card_template == :full_body
      {
        width: 297,
        height: 443
      }
    elsif resource.is_a?(QuestionSerializer)
      {
        width: 297,
        height: 220
      }
    else
      {
        width: 297,
        height: 191
      }
    end
  end

  private

  def resource
    @resource ||= object.resource.serializer(scope: scope)
  end

  def state_specific_date
    if object.saved?
      {
        :read_date => object.state_changed_at,
        :save_date => object.state_changed_at,
        :dismiss_date => ''
      }
    else
      {}
    end
  end
end
