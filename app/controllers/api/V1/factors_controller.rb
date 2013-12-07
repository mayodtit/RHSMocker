class Api::V1::FactorsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_symptom!

  # TODO - change interface to simplify this method
  #
  # here's what it does now:
  #  1. get all SymptomsFactors for a Symptom
  #  2. include all related Factors and FactorGroup so we don't have n+1 queries
  #  3. sort SymptomsFactors by Factor name so results have Factors sorted by name
  #  4. put Factors into buckets by FactorGroup
  #  5. map hash to array specification [{name: FactorGroup.name, factors: [Factor(s)]}]
  #  6. sort array by FactorGroup.id
  def index
    @factor_groups = @symptom.symptoms_factors
                             .includes(:factor, :factor_group)
                             .sort_by{|sf| sf.factor.name}
                             .inject(Hash.new{[]}) do |result, symptoms_factor|
      result[symptoms_factor.factor_group] <<= symptoms_factor
      result
    end.map{|k,v| {name: k.name, factors: v}}.sort_by{|fg| fg[:id]}
    render_success factor_groups: @factor_groups
  end

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
