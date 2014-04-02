class CreateMasterConsultsForMembers < ActiveRecord::Migration
  def up

    # this is required since the previous migration adds a column to Consult,
    # which isn't reflected in the cached version of the model if this
    # migration executes in the same rake command
    Consult.reset_column_information

    Member.joins('LEFT OUTER JOIN consults ON consults.initiator_id = users.id AND consults.master = true')
          .where(consults: {id: nil})
          .each do |user|
            user.create_master_consult!(subject: user,
                                        title: 'Direct messaging with your Better PHA',
                                        skip_tasks: true)
          end
  end

  def down
  end
end
