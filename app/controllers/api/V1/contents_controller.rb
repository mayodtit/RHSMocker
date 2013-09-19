class Api::V1::ContentsController < Api::V1::ABaseController
  before_filter :load_contents!, :only => :index
  before_filter :load_content!, :only => :show

  def index
    index_resource(@contents)
    Analytics.log_content_search(current_user.google_analytics_uuid, params[:q]) if current_user
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

  private

  def load_contents!
    @contents = params[:q].blank? ? Content.order('title ASC') : solr_results
  end

  def solr_results
    Content.solr_search do |s|
      @contents = s.keywords params[:q]
      @searchterm = params[:q]
    end
  end

  def load_content!
    @content = Content.find(params[:id])
  end

  def merge_body(content)
    content.as_json.merge!(:body => render_to_string(:action => :show,
                                                     :formats => :html,
                                                     :locals => {:content => content}))
  end
end
