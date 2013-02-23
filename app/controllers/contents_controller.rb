class ContentsController < ApplicationController
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
      h = {"layout" => "cardview"}
    else
      h = {}
    end

    respond_to do |format|
      format.html { render :text => @content.as_html(h) }
      format.json { render :json => @content.as_json(h) }
    end
  end

end
