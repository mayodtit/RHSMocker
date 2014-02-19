class Api::V1::PermissionsController < Api::V1::ABaseController
  before_filter :load_association!
  before_filter :load_permission!, only: %i(update destroy)

  def index
    index_resource @association.permissions
  end

  def create
    create_resource @association.permissions, permitted_params.permission
  end

  def update
    update_resource @permission, permitted_params.permission
  end

  def destroy
    destroy_resource @permission
  end

  private

  def load_association!
    @association = Association.find(params[:association_id])
    authorize! :manage, @association
  end

  def load_permission!
    @permission = @association.permissions.find(params[:id])
    authorize! :manage, @permission
  end
end
