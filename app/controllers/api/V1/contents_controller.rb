class Api::V1::ContentsController < Api::V1::ABaseController
  # GET /contents
  # GET /contents.json
  def index
    #@contents = Content.all

    @contents = if params[:q].blank?
      Content.all :order => 'title ASC'
    else
      Content.solr_search do |s|
         @contents = s.keywords params[:q]
         @searchterm = params[:q]
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contents }
    end

  end

   # GET /contents/1
  # GET /contents/1.json
  def show
    @content = Content.find(params[:id])
    
    if params[:q] == 'cardview'
      first_paragraph = @content.firstParagraph
      html = render_to_string :action => "content_cardview", :formats=>:html, :locals => {:first_paragraph => first_paragraph}
      options = {"layout" => "cardview", "source" => html}
    else
      html =  render_to_string :action => "content_full", :formats=>:html
      options = {"source" => html}
    end

    respond_to do |format|
      format.html { render :text => html}
      format.json { render :json => @content.as_json(options)}
    end
  end
end
