class PhaProfilesController < ApplicationController
  layout 'public_page_layout'

  def show
    @pha_profile = PhaProfile.find(params[:id])
  end
end
