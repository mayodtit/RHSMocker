class Api::V1::ContentsController < Api::V1::ABaseController

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

    user_reading = UserReading.find_by_user_id_and_content_id(current_user.id, @content.id) || UserReading.create(view_date:DateTime.now, user_id:current_user.id, content_id:@content.id)

    render_success content:@content.as_json({"source"=>html, :user_reading_id=>user_reading.id})
  end

end
