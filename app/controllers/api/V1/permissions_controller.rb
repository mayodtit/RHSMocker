class Api::V1::PermissionsController < Api::V1::ABaseController
  before_filter :load_association!
  before_filter :load_permission!

  def show
    authorize! :read, @permission
    show_resource @permission.serializer
  end

  def update
    authorize! :manage, @permission
    update_resource @permission, permitted_params.permission
  end

  private

  def load_association!
    @association = Association.find(params[:id])
    authorize! :manage, @association
  end

  def load_permission!
    @permission = @association.permission
  end
end
