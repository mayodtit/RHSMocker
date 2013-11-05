class Api::V1::ContentsController < Api::V1::ABaseController
  skip_before_filter :authentication_check, only: :show
  before_filter :load_contents!, only: :index
  before_filter :load_content!, only: :show
  after_filter :log_content_search, only: :index

  def index
    index_resource(@contents.active_model_serializer_instance)
  end

  def show
    show_resource(merge_body(@content))
  end

  def status
    @user = current_user
    @content = Content.find(params[:id])
    @card = @user.cards.for_resource(@content) || @user.cards.build(:resource => @content)
    update_resource(@card, params[:card], :card)
  end

  def like
    current_user.like_content(params[:content_id])
    render_success
  end

  def dislike
    current_user.dislike_content(params[:content_id])
    render_success
  end

  def remove_like
    current_user.remove_content_like(params[:content_id])
    render_success
  end

  private

  def load_contents!
    @contents = params[:q].blank? ? Content.order('title ASC') : solr_results
  end

  def solr_results
    query = Content.sanitize_solr_query(params[:q])
    Content.search{ fulltext query }.results
  end

  def load_content!
    @content = Content.find(params[:id])
  end

  def log_content_search
    Analytics.log_content_search(current_user.google_analytics_uuid, params[:q]) if current_user
  end

  def merge_body(content)
    content.active_model_serializer_instance.as_json.merge!(:body => render_to_string(:action => :show,
                                                            :formats => :html,
                                                            :locals => {:content => content.decorate}))
  end
end
