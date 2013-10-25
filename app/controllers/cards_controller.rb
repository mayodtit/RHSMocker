class CardsController < ApplicationController
  def show
    @card = Card.find(params[:id])
    render :template => 'api/v1/cards/preview', :locals => {:card => @card, :resource => @card.resource}
  end
end
