class Api::V1::AssociationsController < Api::V1::ABaseController

  def create
    return render_failure({reason: "Association not supplied"}, 412) unless params[:association].present? 
    associate = Associate.new params[:associate]
    associate.save(:validate=>false)
    return render_failure( {reason:"Could not create an associate"}, 412 ) if associate.nil?
    association = Association.create params[:association].merge({:user=>current_user, :associate=>associate}) 
    return render_failure( {reason:association.errors.full_messages.to_sentence}, 412 ) unless association.errors.empty?
    render_success({association:association})
  end

  def index
    render_success({associations:current_user.associations})
  end

  def edit

  end

  def remove

  end

end