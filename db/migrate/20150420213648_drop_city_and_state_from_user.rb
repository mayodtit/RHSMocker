class DropCityAndStateFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :city

    ## Determine if the User table has the state column - see https://www.pivotaltracker.com/story/show/91862844
    ## There was a problem dropping users.state in the past, so the schema didn't show it but the production db
    ##   still had the column. This code below lets the migration run on prod without breaking dev/qa dbs that
    ##   don't have that weird state
    q = <<-SQL
      SELECT count(column_name)
        FROM information_schema.columns
       WHERE table_name = "users"
         AND column_name = "state"
    SQL
    ActiveRecord::Base.establish_connection
    state_column_exists = (ActiveRecord::Base.connection.execute(q).entries[0][0] != 0) ## I know this is gross
    if state_column_exists
      puts "*** STATE COLUMN EXISTS - DROPPING VIA SQL ***"
      q = <<-SQL
            ALTER TABLE users
            DROP COLUMN state
          SQL
      ActiveRecord::Base.connection.execute(q)
    end
  end

  def down
    add_column :users, :city, :string
    add_column :users, :state, :string
  end
end
