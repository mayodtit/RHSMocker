class Api::V1::RolesController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_role!

  def members
    authorize! :read, @role

    members_with_role = @role.users.members

    index_resource members_with_role, name: 'members'
  end

  private

  def load_role!
    @role = Role.find_by_name! params[:role_name]
  end
end