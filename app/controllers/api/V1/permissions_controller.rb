class Api::V1::PermissionsController < Api::V1::ABaseController
  before_filter :load_association!, except: :available
  before_filter :load_permission!, only: %i(update destroy)

  def index
    index_resource @association.permissions
  end

  # TODO - this feels like the wrong solution and it is a workaround to allow
  #        the client to progress.  The presence of this endpoint makes me
  #        feel that the current permissions model is not correct.
  def available
    render_success(permissions: [{name: 'basic_info', display_name: 'Basic Information', levels: [:view, :edit]},
                                 {name: 'medical_info', display_name: 'Medical Information', levels: [:none, :view, :edit]},
                                 {name: 'care_team', display_name: 'Care Team', levels: [:none, :view, :edit]}])

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
