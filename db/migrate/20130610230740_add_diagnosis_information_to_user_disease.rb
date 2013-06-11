class AddDiagnosisInformationToUserDisease < ActiveRecord::Migration
  def change
    add_column :user_diseases, :diagnoser_id, :integer
    add_column :user_diseases, :diagnosed_date, :datetime
  end
end
