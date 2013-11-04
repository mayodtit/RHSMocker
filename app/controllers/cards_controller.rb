class CardsController < ApplicationController
  def show
    @card = Card.find(params[:id])
    if params[:type] == 'show'
      render :template => 'api/v1/cards/show', :locals => {:card => @card, :resource => @card.resource}
    else
      render :template => 'api/v1/cards/preview', :locals => {:card => @card, :resource => @card.resource}
    end
  end
end
