class RemoveServiceTemplateSeeds < ActiveRecord::Migration
  def up
    TaskTemplate.destroy_all
    ServiceTemplate.destroy_all
  end

  def down
  end
end
