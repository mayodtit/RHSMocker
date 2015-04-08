class Api::V1::UserFilesController < Api::V1::ABaseController
  before_filter :load_user!

  def create
    create_resource @user.user_files, {file: permitted_params.user_file[:file]}
  end
end
