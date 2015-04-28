class Api::V1::EntriesController < Api::V1::ABaseController
  before_filter :load_member!
  before_filter :load_entries!

  def index
    render_success(entries: entries.serializer,
                   total_count: @total_count_per_user)
  end

  private

  def entries
    base_entries_with_pagination.includes(:member).sort_by(&:created_at)
  end

  def base_entries_with_pagination
    if show_all?
      @entries
    else
      base_entries_scopes.page(page_number).per(page_size).padding(offset)
    end
  end

  def base_entries_scopes
    @entries.order('created_at DESC').order('id DESC')
  end

  def page_number
    @page_number ||= params[:page] || 1
  end

  def page_size
    @page_size ||= params[:per] || Metadata.default_page_size
  end

  def offset
    @offset ||= params[:offset] || 0
  end

  def show_all?
    params[:show_all].present?
  end

  def load_entries!
    authorize! :read, Entry
    @entries = @member.entries.where("!(resource_type = 'Task' && actor_id = ?)", Member.robot.id)
    @total_count_per_user = @entries.count
  end
end
