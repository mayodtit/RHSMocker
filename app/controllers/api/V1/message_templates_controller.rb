class Api::V1::MessageTemplatesController < Api::V1::ABaseController
  before_filter :load_message_templates!
  before_filter :load_message_template!, only: %i(show update destroy)

  def index
    index_resource @message_templates.serializer
  end

  def show
    show_resource @message_template.serializer
  end

  def create
    create_resource @message_templates, permitted_params.message_template
  end

  def update
    update_resource @message_template, permitted_params.message_template
  end

  def destroy
    destroy_resource @message_template
  end

  private

  def load_message_templates!
    authorize! :manage, MessageTemplate
    @message_templates = MessageTemplate.scoped
  end

  def load_message_template!
    @message_template = @message_templates.find(params[:id])
    authorize! :manage, @message_template
  end
end
