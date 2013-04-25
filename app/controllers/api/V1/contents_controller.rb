class Api::V1::ContentsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    @contents = if params[:q].blank?
      Content.all :order => 'title ASC'
    else
      Content.solr_search do |s|
         @contents = s.keywords params[:q]
         @searchterm = params[:q]
      end
    end
    render_success({contents:@contents})
  end

  def show
    @content = Content.find_by_id(params[:id])
    return render_failure({reason:"Content not found"}, 404) unless @content
    html = if params[:q] == 'cardview'
      render_to_string :action => "content_cardview", :formats=>:html, :locals => {:first_paragraph => @content.previewText}
    else
      render_to_string :action => "content_full", :formats=>:html
    end

    render_success @content.as_json({"source"=>html})
  end

end
