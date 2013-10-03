class CapitalizeFactorNames < ActiveRecord::Migration
  def up

    # names were found with 'Factor.all.map {|f| f.name == f.name.capitalize ? nil : f.name}.compact'
    bad_names = ['Burning Pain', 'Coughing or Jarring Movements', 'Intermittent, Episodic', 'Radiates from Abdomen', 'Stiff Neck']
    Factor.where(name: bad_names).each { |f| f.update_attributes(name: f.name.capitalize) }
  end

  def down
    # nothing
  end
end
