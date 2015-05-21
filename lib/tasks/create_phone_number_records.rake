namespace :admin do
  task :create_phone_number_records, [:exec] => :environment do |t, args|
    execute_arg = args[:exec] || "false"
    commit_changes = (execute_arg == "true")

    puts "DRY RUN - No database updates" unless commit_changes

    n = User.count
    i = 0
    invalid_phone_numbers = []

    User.find_each do |user|
      puts "#{(i+1).to_s.rjust(5)}/#{n} - User id##{user.id}"
      upsert_user_phone_numbers(user, commit_changes, invalid_phone_numbers)

      if (i % 100 == 0) && i != 0
        sleep 1
      end
      i += 1
    end

    unless invalid_phone_numbers.empty?
      puts "INVALID NUMBERS:"
      invalid_phone_numbers.each do |h|
        puts "  Number: #{h[:number]} - User: #{h[:id]} - Type: #{h[:type]}"
      end
    end
  end

  def upsert_user_phone_numbers(user, commit_changes, invalid_phone_numbers)
    if user.phone.present? && user.phone_obj.nil?
      puts "    Creating PRIMARY phone number - #{user.phone}"
      new_phone = user.phone_numbers.build(number: user.phone, primary: true, type: "Home")
      if new_phone.valid?
        if commit_changes
          new_phone.save
        end
      else
        puts "    - invalid, not saving"
        invalid_phone_numbers << {id: user.id, type: "Home", number: user.phone}
      end
    end
    if user.work_phone_number.present? && user.work_phone_number_obj.nil?
      puts "    Creating WORK phone number - #{user.work_phone_number}"
      new_work_phone = user.phone_numbers.build(number: user.work_phone_number, primary: false, type: "Work")
      if new_work_phone.valid?
        if commit_changes
          new_work_phone.save
        end
      else
        puts "    - invalid, not saving"
        invalid_phone_numbers << {id: user.id, type: "Work", number: user.work_phone_number}
      end
    end
    if user.text_phone_number.present? && user.text_phone_number_obj.nil?
      puts "    Creating MOBILE phone number - #{user.text_phone_number}"
      new_mobile_phone = user.phone_numbers.build(number: user.text_phone_number, primary: false, type: "Mobile")
      if new_mobile_phone.valid?
        if commit_changes
          new_mobile_phone.save
        end
      else
        puts "    - invalid, not saving"
        invalid_phone_numbers << {id: user.id, type: "Mobile", number: user.text_phone_number}
      end
    end
  end
end
