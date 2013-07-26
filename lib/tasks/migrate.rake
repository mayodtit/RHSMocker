namespace :migrate do
  task :covert_user_readings_to_items => :environment do
    total = UserReading.count
    i = 0
    UserReading.find_each do |ur|
      if ur.dismiss_date
        state = 'dismissed'
        date = ur.dismiss_date
      elsif ur.save_date
        state = 'saved'
        date = ur.save_date
      elsif ur.read_date
        state = 'read'
        date = ur.read_date
      else
        state = 'unread'
        date = nil
      end

      item = Item.where(:user_id => ur.user_id,
                        :resource_id => ur.content_id,
                        :resource_type => 'Content').first_or_initialize
      item.update_attributes(:state => state,
                             :state_changed_at => date)

      i += 1
      if item.errors.empty?
        print '.'
      else
        print '!'
      end
      puts i if (i % 100) == 0
    end
  end
end
