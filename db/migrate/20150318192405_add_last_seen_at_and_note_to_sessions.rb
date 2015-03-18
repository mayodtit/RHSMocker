class AddLastSeenAtAndNoteToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :last_seen_at, :datetime
    add_column :sessions, :note, :string
  end
end
