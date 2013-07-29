namespace :migrate do
  task :covert_user_readings_to_items => :environment do
    total = UserReading.count
    i = 0
    UserReading.find_each do |ur|
      if ur.dismiss_date
        state = 'dismissed'
      elsif ur.save_date
        state = 'saved'
      elsif ur.read_date
        state = 'read'
      else
        state = 'unread'
      end

      item = Item.where(:user_id => ur.user_id,
                        :resource_id => ur.content_id,
                        :resource_type => 'Content').first_or_initialize
      if item.new_record? || ur.updated_at > item.updated_at
        item.update_attributes(:state => state,
                               :read_at => ur.read_date,
                               :saved_at => ur.save_date,
                               :dismissed_at => ur.dismiss_date)
        if item.errors.empty?
          print '.'
        else
          print '!'
        end
      else
        print '-'
      end

      i += 1
      puts "#{i}/#{total}" if (i % 100) == 0
    end
    puts "\nAll done!"
  end
end
