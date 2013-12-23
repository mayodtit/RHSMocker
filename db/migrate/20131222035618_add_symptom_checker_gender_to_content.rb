class AddSymptomCheckerGenderToContent < ActiveRecord::Migration
  def change
    add_column :contents, :symptom_checker_gender, :string
  end
end
