namespace :migrate do
  task :covert_user_readings_to_cards => :environment do
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

      card = Card.where(:user_id => ur.user_id,
                        :resource_id => ur.content_id,
                        :resource_type => 'Content').first_or_initialize
      if card.new_record? || ur.updated_at > card.updated_at
        card.update_attributes(:state => state,
                               :read_at => ur.read_date,
                               :saved_at => ur.save_date,
                               :dismissed_at => ur.dismiss_date)
        if card.errors.empty?
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

  task :convert_message_statuses_to_cards => :environment do
    total = MessageStatus.count
    i = 0
    MessageStatus.find_each do |ms|
      case ms.status
      when 'unread'
        attributes = {state: :unread}
      when 'read'
        attributes = {state: :read, read_at: ms.updated_at}
      when 'dismissed'
        attributes = {state: :dismissed, read_at: ms.updated_at, dismissed_at: ms.updated_at}
      end

      card = Card.where(:user_id => ms.user_id,
                        :resource_id => ms.message_id,
                        :resource_type => 'Message').first_or_initialize
      if card.new_record? || ur.updated_at > card.updated_at
        card.update_attributes(attributes)
        if card.errors.empty?
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
