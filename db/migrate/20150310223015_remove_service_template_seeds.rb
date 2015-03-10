class RemoveServiceTemplateSeeds < ActiveRecord::Migration
  def up
    TaskTemplate.try(:destroy_all)
    ServiceTemplate.try(:destroy_all)
  end

  def down
  end
end
