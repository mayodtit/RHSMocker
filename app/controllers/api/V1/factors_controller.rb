class Api::V1::FactorsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_symptom!

  # TODO - change inteface to simplify this method
  #
  # here's what check does now
  #  1. retrieve all contents referred to by given SymptomsFactors ids
  #  2. uniq the records to remove duplicates resulting of join
  #  3. map records to resulting specification, compute SymptomsFactor name from Factor and FactorGroup
  #  4. sort the results by the number of matching Factors records (ascending)
  #  5. put the thing down, flip it, and reverse it (descending)
  def check
    @contents = Content.joins(:symptoms_factors)
                       .where(symptoms_factors: {id: params[:symptoms_factors]})
                       .group('contents.id')
                       .map do |content|
      {
        id: content.id,
        name: content.title,
        factors: content.symptoms_factors.where(symptom_id: @symptom.id)
                                         .includes(:factor, :factor_group)
                                         .map{|sf| {id: sf.id, name: "#{sf.factor_group.name.capitalize } #{sf.factor.name.downcase}"}}
      }
    end.sort_by!{|result| (result[:factors].map{|f| f[:id]} & params[:symptoms_factors]).count}.reverse!
    render_success contents: @contents
  end

  private

  def load_symptom!
    @symptom = Symptom.find(params[:id] || params[:symptom_id])
  end
end
