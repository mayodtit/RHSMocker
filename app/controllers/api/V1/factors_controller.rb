class Api::V1::FactorsController < Api::V1::ABaseController
  skip_before_filter :authentication_check, :only=>:index

 #  {
	#   "factor_groups":[
	#      {"name":"pain is",
	#        "factors":[
	#              {"name":"acute",    "symptoms_factor_id":"24"},
	#              {"name":"intense",    "symptoms_factor_id":"25"}
	#         ]
	#       }
	#   ]
	# }
  def index
    # symptom = Symptom.find_by_id params[:id]
    # return render_failure({reason:"Symptom with id #{params[:id]} could not be found"}, 404) unless symptom
    # result = {:factor_groups=>[]}
    # symptom.symptoms_factors.each  do |symptoms_factor|
    # 	# add group to a set, add factor to that group
    # 	result.factor_groups << {:name=>}
    # end
  end

  def check

  end

end
