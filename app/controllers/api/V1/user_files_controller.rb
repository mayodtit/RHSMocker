class Api::V1::UserFilesController < Api::V1::ABaseController
  before_filter :load_user!

  def create
    create_resource @user.user_files, user_file_attributes
  end

  private

  def user_file_attributes
    {file: CarrierwaveStringIO.new(Base64.decode64(permitted_params.user_file[:file]))}
  end
end
