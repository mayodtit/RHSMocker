class Api::V1::AssociationsController < Api::V1::ABaseController
  include ActiveModel::MassAssignmentSecurity

  before_filter :check_association, :except=>:index

  attr_accessible :first_name, :last_name, :npi_number, :expertise

  def create
    if params[:association][:user_id]
      user = User.find_by_id(params[:association][:user_id])
      return render_failure({reason:"User with id #{params[:association][:user_id]} is not found"}, 404) unless user
      return render_failure({reason:"Permission denied to edit user with id #{params[:association][:user_id]}"}) if !current_user.allowed_to_edit_user?(user.id) && !current_user.hcp?
    else
      user = current_user
    end

    associate = create_associate(params)
    return render_failure( {reason:"Could not create an associate #{params[:association][:associate]}"}, 412 ) if associate.nil?
    association_type = AssociationType.find_by_id params[:association][:association_type_id]
    return render_failure( {reason:"Could not find association type id #{params[:association][:association_type_id]}"}, 404 ) if association_type.nil?
    association = Association.create params[:association].merge({:user=>user, :associate=>associate})
    return render_failure( {reason:association.errors.full_messages.to_sentence}, 412 ) unless association.errors.empty?
    render_success({association:association})
  end

  def index
    if params[:user_id]
      user = User.find_by_id(params[:user_id])
      return render_failure({reason:"User with id #{params[:user_id]} is not found"}, 404) unless user
      return render_failure({reason:"Permission denied to view associates of user with id #{params[:user_id]}"}) if !current_user.allowed_to_edit_user?(user.id) && !current_user.hcp?
    else
      user = current_user
    end

    render_success({associations:user.associations})
  end

  def update
    association = Association.find_by_id params[:association][:id]
    return render_failure({reason: "Could not find association with id #{params[:association][:id]}"}, 404) unless association
    return render_failure({reason:"Permission denied to edit user with id #{association.user_id}"}) if !current_user.allowed_to_edit_user?(association.user_id) && !current_user.hcp?
    association_type = AssociationType.find_by_id params[:association][:association_type_id]
    return render_failure( {reason:"Could not find association type id #{params[:association][:association_type_id]}"}, 404 ) if association_type.nil?
    association.update_attributes params[:association]
    return render_failure({reason:association.errors.full_messages.to_sentence}, 422) unless association.errors.empty?
    render_success({association:association})
  end

  def remove
    association = Association.find_by_id params[:association][:id]
    return render_failure({reason: "Could not find association with id #{params[:association][:id]}"}, 404) unless association
    return render_failure({reason:"Permission denied"}) if !current_user.allowed_to_edit_user?(association.user_id) && !current_user.hcp?
    if Association.destroy(association.id)
      render_success
    else
      render_failure({reason:association.errors.full_messages.to_sentence}, 422)
    end
  end

  private

  def check_association
    return render_failure({reason: "Association not supplied"}, 412) if params[:association].empty?
  end

  def create_associate(params)
    if params[:association][:associate].try(:[], :npi_number)
      associate = Associate.find_by_npi_number(params[:association][:associate][:npi_number])
      return associate if associate
      associate = Associate.new sanitize_for_mass_assignment(search_service.find(:npi_number => params[:association][:associate][:npi_number]))
      associate.save(:validate=>false)
      associate
    else
      associate = Associate.new params[:association][:associate]
      associate.save(:validate=>false)
      associate
    end
  end

  def search_service
    @search_service ||= Search::Service.new
  end
end
