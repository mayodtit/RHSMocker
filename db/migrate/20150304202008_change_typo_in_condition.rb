class ChangeTypoInCondition < ActiveRecord::Migration
  def change
    if condition = Condition.find_by_name('Evelated Blood Pressure')
      condition.name = 'Elevated Blood Pressure'
      condition.save!
    end
  end
end
