class AgreementsController < ApplicationController
  layout 'public_page_layout'
  before_filter :load_agreement

  def current
    render :show
  end

  private

  def load_agreement
    @agreement = Agreement.active
    raise ActiveRecord::RecordNotFound unless @agreement
  end
end
