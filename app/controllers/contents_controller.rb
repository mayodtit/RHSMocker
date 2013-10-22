class ContentsController < ApplicationController
  def index
    @contents = Content.order('title ASC').page(params[:page]).per(200)
    respond_to do |format|
      format.html
      format.json { render json: @contents }
      format.csv { send_data Content.to_csv }
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
