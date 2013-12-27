class Api::V1::SymptomContentsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_symptom!
  before_filter :load_contents!

  def index
    index_resource @contents, name: :contents
  end

  private

  def load_symptom!
    @symptom = Symptom.find(params[:symptom_id])
  end

  def load_contents!
    @contents = Content.joins(:factors => :symptom)
                       .where(symptoms: {id: @symptom.id})
    @contents = @contents.where(factors: {id: params[:factor_ids]}) if params[:factor_ids]
  end
end
