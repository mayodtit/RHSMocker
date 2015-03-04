class ChangeTypoInCondition < ActiveRecord::Migration
  def change
  	condition = Condition.find_by_name('Evelated Blood Pressure')
  	if condition
  	  condition.name = 'Elevated Blood Pressure'
  	  condition.save!
  	end
  end
end
