class Api::V1::EnrollmentsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_enrollment!, only: %i(show update)

  def show
    show_resource @enrollment.serializer
  end

  def create
    create_resource Enrollment, permitted_params.enrollment
  end

  def update
    update_resource @enrollment, permitted_params.enrollment
  end

  private

  def load_enrollment!
    @enrollment = Enrollment.find_by_token!(params[:id])
  end
end
