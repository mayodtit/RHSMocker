namespace :admin do
  task :create_phone_number_records, [:exec] => :environment do |t, args|
    execute_arg = args[:exec] || "false"
    commit_changes = (execute_arg == "true")

    puts "DRY RUN - No database updates" unless commit_changes

    n = User.count
    i = 0

    User.find_each do |user|
      puts "#{(i+1).to_s.rjust(5)}/#{n} - User id##{user.id}"
      upsert_user_phone_numbers(user, commit_changes)

      if (i % 100 == 0) && i != 0
        sleep 1
      end
      i += 1
    end
  end

  def upsert_user_phone_numbers(user, commit_changes)
    if user.phone.present? && user.phone_obj.nil?
      puts "  Creating PRIMARY phone number"
      user.phone_numbers.create(number: user.phone, primary: true, type: "Home") if commit_changes
    end
    if user.work_phone_number.present? && user.work_phone_number_obj.nil?
      puts "  Creating WORK phone number"
      user.phone_numbers.create(number: user.work_phone_number, primary: false, type: "Work") if commit_changes
    end
    if user.text_phone_number.present? && user.text_phone_number_obj.nil?
      puts "  Creating MOBILE phone number"
      user.phone_numbers.create(number: user.text_phone_number, primary: false, type: "Mobile") if text_phone_number
    end
  end
end
