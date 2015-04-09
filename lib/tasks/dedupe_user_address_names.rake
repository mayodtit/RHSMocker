namespace :admin do
  task :deduplicate_user_address_names, [:execute] => :environment do |t, args|
    execute_arg = args[:execute] || "false"
    commit_changes = (execute_arg == "true")

    puts "DRY RUN - No database updates" unless commit_changes

    User.includes(:addresses).find_each do |user|
      puts "Fixing address names for user ID##{user.id} - #{user.email}"

      user.addresses.group_by(&:name).each do |name, addresses|
        next if addresses.length == 1

        puts "   Renaming addresses named '#{name}'"

        addresses[1..-1].each_with_index do |addr, i|
          new_name = "#{addr.name}-#{i+2}"

          puts "      Renaming address #{addr.name} to #{new_name}"

          if commit_changes
            addr.name = new_name
            addr.save!
          end
        end
      end
    end
  end
end
