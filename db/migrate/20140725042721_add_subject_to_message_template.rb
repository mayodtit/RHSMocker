class AddSubjectToMessageTemplate < ActiveRecord::Migration
  def change
    add_column :message_templates, :subject, :string
  end
end
