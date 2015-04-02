class Api::V1::UserFilesController < Api::V1::ABaseController
  before_filter :load_user!

  def create
    create_resource @user.user_files, {file: Base64.encode64(permitted_params.user_file[:file])}
  end
end
