class ContentsController < ApplicationController
  def index
    if params[:search]
      @contents = Content.where('title LIKE ? OR raw_body LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
    else
      @contents = Content
    end
    @contents = @contents.order('title ASC').page(params[:page]).per(200)
    respond_to do |format|
      format.html
      format.json { render json: @contents }
      format.csv { send_data MayoContent.to_csv }
    end
  end

  def show
    @content = Content.find_by_document_id(params[:id]) || Content.find(params[:id])
    if params[:type] == 'card'
      render :template => 'api/v1/cards/preview', :locals => {:card => nil, :resource => @content.serializer}
    else
      render :template => 'api/v1/contents/show', :locals => {content: @content.serializer}
    end
  end
end
