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
    if @enrollment.update_attributes(permitted_params.enrollment)
      render_success(enrollment: @enrollment.serializer,
                     next_action: next_action,
                     trial_story: trial_story,
                     success_story: success_story)
    else
      render_failure({reason: @enrollment.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def load_enrollment!
    @enrollment = Enrollment.find_by_token!(params[:id])
  end

  def stories
    NuxStory.enabled.serializer.as_json
  end

  def next_action
    'credit_card'
  end

  def trial_story
    NuxStory.trial.try(:serializer)
  end

  def success_story
    NuxStory.sign_up_success.try(:serializer)
  end
end
