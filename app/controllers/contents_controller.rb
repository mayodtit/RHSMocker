class ContentsController < ApplicationController
  def index
    @contents = if params[:q].blank?
      Content.all :order => 'title ASC'
    else
      Content.solr_search do |s|
         @contents = s.keywords params[:q]
         @searchterm = params[:q]
      end
    end

    respond_to do |format|
      format.html
      format.json { render json: @contents }
    end
  end

  def show
    @content = Content.find_by_mayo_doc_id(params[:id]) || Content.find(params[:id])
    if params[:type] == 'card'
      render :template => 'api/v1/cards/preview', :locals => {:resource => @content.decorate}
    else
      render :template => 'api/v1/contents/show'
    end
  end
end
