class Api::V1::AssociatesController < Api::V1::UsersController
  before_filter :authentication_check

  def update
    params[:associate].delete :password
    return render_failure({reason:"Not authorized to edit this associate"}) unless  current_user.allowed_to_edit_user? params[:id].to_i
    associate = Associate.find_by_id params[:id]
    return render_failure({reason:"Associate not found"}, 404) unless associate
    if associate.update_attributes(params[:associate])
      render_success({associate:associate})
    else
      render_failure({reason:associate.errors.full_messages.to_sentence}, 422)
    end
  end
end
