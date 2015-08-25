class Api::V1::SpecialistsController < Api::V1::ABaseController
  before_filter :load_specialists!, only: :index
  before_filter :load_queue!, only: :queue

  def index
    index_resource @specialists.serializer(specialist: true)
  end

  def queue
    render_success(queue: @queue.serializer(shallow: true))
  end

  private

  def load_specialists!
    @specialists = Member.specialists
  end

  def load_queue!
    @queue = Task.specialist_queue_today
  end
end
