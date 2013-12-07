class Api::V1::ContentsController < Api::V1::ABaseController
  before_filter :unlock_contents!
  before_filter :load_contents!, only: :index
  before_filter :load_content!, only: :show
  after_filter :log_content_search, only: :index

  def index
    render_success(contents: @contents.serializer,
                   page: page,
                   per: per,
                   total_count: @total_count)
  end

  def show
    show_resource @content.serializer(body: true,
                                      preview: params[:preview] || false,
                                      raw_body: params[:raw_body] || false,
                                      raw_preview: params[:raw_preview] || false)
  end

  def status
    @user = current_user
    @content = Content.find(params[:id])
    @card = @user.cards.for_resource(@content) || @user.cards.build(:resource => @content)
    update_resource @card, params[:card], name: :card
  end

  def like
    current_user.like_content params[:content_id]
    render_success
  end

  def dislike
    current_user.dislike_content params[:content_id]
    render_success
  end

  def remove_like
    current_user.remove_content_like params[:content_id]
    render_success
  end

  private

  def unlock_contents!
    if params[:state] == 'all'
      raise CanCan::AccessDenied unless current_user.admin?
      @unlocked = true
    end
  end

  def load_contents!
    params[:q].blank? ? load_from_sql! : load_from_solr!
  end

  def load_from_sql!
    @contents = Content.order('title ASC')
    @contents = @contents.published unless @unlocked
    @contents = @contents.where(:type => params[:type]) if params[:type]
    @contents = @contents.page(page).per(per)
    @total_count = @contents.total_count
  end

  def load_from_solr!
    query = Content.sanitize_solr_query params[:q]
    unlocked = @unlocked
    solr_query = Content.search do
      fulltext query
      paginate page: page, per_page: per
      with :type, params[:type] if params[:type]
      with :state, :published unless unlocked
    end
    @total_count = solr_query.total
    @contents = solr_query.results
  end

  def load_content!
    @content = if @unlocked
                 Content.find params[:id]
               else
                 Content.published.find params[:id]
               end
  end

  def log_content_search
    Analytics.log_content_search(current_user.google_analytics_uuid, params[:q]) if current_user
  end

  def page
    params[:page] || 1
  end

  def per
    params[:per] || 50
  end
end
