class MayoVocabulariesController < ApplicationController
  def index
    respond_to do |format|
      format.csv { send_data MayoVocabulary.to_csv }
    end
  end
end
