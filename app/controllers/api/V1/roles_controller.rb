class Api::V1::RolesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_role!

  def members
    authorize! :read, Role

    members_with_role = User.with_role(@role.name).find_all_by_type('Member')

    index_resource members_with_role, name: 'members'
  end

  private

  def load_role!
    @role = Role.find_by_name! params[:role_name]
  end
end