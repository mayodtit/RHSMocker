class Api::V1::DataFieldsController < Api::V1::ABaseController
  before_filter :load_user!
  before_filter :load_data_field!

  def show
    show_resource @data_field.serializer
  end

  def update
    update_resource @data_field, permitted_params.data_field
  end

  private

  def load_data_field!
    @data_field = DataField.find(params[:id])
    authorize! :manage, @data_field
  end
end
