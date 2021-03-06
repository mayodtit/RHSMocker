class Api::V1::SymptomContentsController < Api::V1::ABaseController
  skip_before_filter :authentication_check
  before_filter :load_symptom!
  before_filter :load_contents!
  before_filter :build_content_results!

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
    @contents = @contents.where(factors: {id: factor_ids}) if factor_ids.any?
  end

  def build_content_results!
    @contents = @contents.uniq.map do |content|
      {
        id: content.id,
        name: content.title,
        gender: content.symptom_checker_gender,
        condition_id: content.condition_id,
        factors: content_factors(content)
      }
    end.sort_by!{|result| [-(result[:factors].map{|f| f[:id]} & factor_ids).count, result[:name]]}
  end

  def factor_ids
    @factor_ids ||= (params[:factor_ids] || params[:symptoms_factors] || []).map(&:to_i)
  end

  def content_factors(content)
    content.factors.joins(:symptom)
                   .where(symptoms: {id: @symptom.id})
                   .includes(:factor_group).map do |factor|
      {
        id: factor.id,
        name: "#{factor.factor_group.name.capitalize} #{factor.name.downcase}",
        gender: factor.gender
      }
    end
  end
end
