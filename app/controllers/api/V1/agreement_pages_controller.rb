class Api::V1::AgreementPagesController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def list
    agreement_pages = AgreementPage.page_types.map do |page_type|
    	AgreementPage.send(page_type).last
    end

    render_success agreement_pages:agreement_pages.compact
  end
end
