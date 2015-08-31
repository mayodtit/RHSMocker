class CreateSystemEventsFromTemplatesService < Struct.new(:params, :options)
  def initialize(params, options={})
    super
  end

  def call
    SystemEvent.create!(
      user: params[:user],
      system_event_template: params[:root_system_event_template],
      trigger_at: params[:trigger_at]
    ).tap do |event|
      create_children!(event)
    end
  end

  private

  def create_children!(parent)
    parent.system_event_template.system_relative_event_templates.each do |template|
      parent.children.create!(
        user: params[:user],
        system_event_template: template,
        trigger_at: template.time_offset.calculate(params[:trigger_at])
      ).tap do |child|
        create_children!(child)
      end
    end
  end
end
