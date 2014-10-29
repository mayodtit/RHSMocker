class Api::V1::EnrollmentsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_enrollment!, only: %i(show update)

  def show
    show_resource @enrollment.serializer
  end

  def create
    @enrollment = Enrollment.create permitted_params.enrollment
    if @enrollment.errors.empty?
      render_success(enrollment: @enrollment.serializer,
                     stories: stories)
    else
      render_failure({reason: @enrollment.errors.full_messages.to_sentence}, 422)
    end
  end

  def update
    update_resource @enrollment, permitted_params.enrollment
  end

  private

  def load_enrollment!
    @enrollment = Enrollment.find_by_token!(params[:id])
  end

  def stories
    NuxStory.enabled.serializer.as_json
  end
end
