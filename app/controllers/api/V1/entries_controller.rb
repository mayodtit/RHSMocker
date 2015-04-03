class Api::V1::EntriesController < Api::V1::ABaseController
  before_filter :load_member!
  before_filter :load_entries!

  def index
    render_success(entries: entries.serializer,
                   total_count: @total_count_per_user)
  end

  private

  def entries
    base_entries_with_pagination
  end

  def base_entries_with_pagination
    if show_all?
      @entries
    else
      base_entries_scopes.page(page_number).per(page_size)
    end
  end

  def base_entries_scopes
    if params[:before]
      @entries.where('id < ?', params[:before]).order('id DESC')
    else
      @entries.order('id DESC')
    end
  end

  def page_number
    @page_number ||= params[:page] || 1
  end

  def page_size
    @page_size ||= params[:per] || Metadata.default_page_size
  end

  def show_all?
    params[:show_all].present?
  end

  def load_entries!
    authorize! :read, Entry
    @entries = @member.entries.order('created_at ASC')
    @total_count_per_user = @entries.count
  end

end
