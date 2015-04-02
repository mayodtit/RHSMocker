class CreateUserFiles < ActiveRecord::Migration
  def self.up
    create_table :user_files do |t|
      t.string :file
      t.references :user
      t.timestamps
    end

    add_index :user_files, :user_id
  end

  def self.down
    drop_table :user_files
  end
end
