class Api::V1::OfferingsController < Api::V1::ABaseController
  before_filter :load_offerings!

  def index
    index_resource(@offerings)
  end

  private

  def load_offerings!
    @offerings = Offering.all
  end
end
