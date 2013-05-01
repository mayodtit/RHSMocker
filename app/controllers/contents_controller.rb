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

  def show
    @content = Content.find_by_mayo_doc_id params[:doc_id]
    #return 404 unless @content
    render :file=>"#{Rails.root}/public/404", :layout=>false, :status=>404 unless @content
    UserReading.increment_counter(:share_counter, params[:user_reading_id]) if params[:user_reading_id]
  end
end
