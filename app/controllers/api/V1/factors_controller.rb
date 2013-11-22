class Api::V1::FactorsController < Api::V1::ABaseController
  skip_before_filter :authentication_check

  def index
    symptom = Symptom.find_by_id params[:id]
    return render_failure({reason:"Symptom with id #{params[:id]} could not be found"}, 404) unless symptom
    factor_groups = []
    factor_groups_json = []
    symptoms_factors = symptom.symptoms_factors.sort_by { |x| [x.id,x.factor.name] }

    symptoms_factors.each do |sf|
      if !factor_groups[sf.factor_group.id]
        temp = {:name=>sf.factor_group.name, :factors=>[]}
        factor_groups[sf.factor_group.id] = temp
        factor_groups_json << temp
      end
      factor_groups[sf.factor_group.id][:factors] << sf
    end
    render_success({:factor_groups=>factor_groups_json})
  end


  def check
    result = []
    #SymptomsFactor.includes(:contents).where(:id=>params[:symptoms_factors])
    Content.joins(:contents_symptoms_factors => :symptoms_factor).where(:contents_symptoms_factors => { :symptoms_factor_id => params[:symptoms_factors]}).includes(:symptoms_factors).uniq.each do |content|
        symptoms_factors = []
        content.symptoms_factors.where(:symptom_id=>params[:symptom_id]).each do |sf|
          symptoms_factors << {:id=>sf.id, :name=>sf.factor_group.name+" "+sf.factor.name}
        end
        # symptoms_factors = content.symptoms_factors.where(:id=>params[:symptoms_factors])

        result << {
          :id=>content.id,
          :name=>content.title,
          :factors=>symptoms_factors
        }
    end

    result.sort! { |a,b| b[:factors].count <=> a[:factors].count }
    render_success({contents:result})
  end

end
