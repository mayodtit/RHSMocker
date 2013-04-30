class Api::V1::AgreementsController < Api::V1::ABaseController

  def list
  	agreements = AgreementPage.page_types.map do |page_type|
    	current_user.agreements.send(page_type).last
    end

    render_success agreements:agreements.compact
  end

  def create
  	return render_failure({reason: "Agreement_page not supplied"}, 412) if params[:agreement_page].blank?
  	return render_failure({reason: "Agreement_page id not supplied"}, 412) if params[:agreement_page][:id].nil?
  	agreement_page = AgreementPage.find_by_id params[:agreement_page][:id]
  	return render_failure({reason: "Could not find agreement_page with id #{params[:agreement_page][:id]}"}, 404) unless agreement_page
  	agreement = Agreement.create(ip_address:request.remote_ip, user_agent:request.env['HTTP_USER_AGENT'],\
  			 user:current_user, agreement_page:agreement_page)

  	if agreement.errors.empty?
  	  render_success agreement:agreement
  	else
      render_failure( {reason:agreement.errors.full_messages.to_sentence}, 422 )
    end
  end

  def up_to_date?
  	AgreementPage.page_types.each do |page_type|
  	  agreement_page = current_user.agreement_pages.send(page_type).last
  	  return render_success({:up_to_date=>false}) if agreement_page.nil? || !agreement_page.latest?
  	end
  	render_success({:up_to_date=>true})
  end
    

end
