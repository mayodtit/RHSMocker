class PhaProfilesController < ApplicationController
  def show
    @pha_profile = PhaProfile.find(params[:id])
  end
end
