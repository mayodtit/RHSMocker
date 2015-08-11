class Api::V1::SystemActionTemplatesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_system_action_templates!
  before_filter :load_system_action_template!, only: %i(show update destroy)

  def index
    authorize! :read, SystemActionTemplate
    index_resource @system_action_templates.serializer
  end

  def create
    authorize! :create, SystemActionTemplate
    create_resource @system_action_templates, permitted_params.system_action_template_attributes
  end

  def show
    authorize! :read, @system_action_template.serializer
  end

  def update
    authorize! :update, @system_action_template
    update_resource @system_action_template, permitted_params.system_action_template_attributes
  end

  def destroy
    authorize! :destroy, @system_action_template
    destroy_resource @system_action_template
  end

  private

  def load_system_action_templates!
    authorize! :index, SystemActionTemplate
    @system_action_templates = SystemActionTemplate.order('id DESC')
  end

  def load_system_action_template!
    @system_action_template = SystemActionTemplate.find(params[:id])
    authorize! :manage, @system_action_template
  end
end