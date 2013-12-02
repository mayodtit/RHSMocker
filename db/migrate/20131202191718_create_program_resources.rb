class CreateProgramResources < ActiveRecord::Migration
  def change
    create_table :program_resources do |t|
      t.references :program
      t.references :resource, polymorphic: true
      t.timestamps
    end
  end
end
