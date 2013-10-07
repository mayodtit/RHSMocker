namespace :migrate do
  task :update_gender_question_resource do
    gender_content = Content.find_by_title!('Your Gender')
    gender_question = Question.find_by_view!(:gender)
    Card.where(:resource_id => gender_content.id,
               :resource_type => 'Content').find_each do |c|
      if c.update_attributes(:resource => gender_question)
        print '.'
      else
        print '!'
      end
    end
  end

  task :update_diet_question_resource do
    diet_content = Content.find_by_title!('Which of these do you eat?')
    diet_question = Question.find_by_view!(:diet)
    Card.where(:resource_id => diet_content.id,
               :resource_type => 'Content').find_each do |c|
      if c.update_attributes(:resource => diet_question)
        print '.'
      else
        print '!'
      end
    end
  end

  task :covert_user_readings_to_cards => :environment do
    total = UserReading.count
    i = 0
    UserReading.find_each do |ur|
      if ur.dismiss_date
        state = 'dismissed'
        state_changed_at = ur.dismiss_date
      elsif ur.save_date
        state = 'saved'
        state_changed_at = ur.save_date
      elsif ur.read_date
        state = 'read'
        state_changed_at = ur.read_date
      else
        state = 'unread'
        state_changed_at = nil
      end

      card = Card.where(:user_id => ur.user_id,
                        :resource_id => ur.content_id,
                        :resource_type => 'Content').first_or_initialize
      if card.new_record? || ur.updated_at > card.updated_at
        card.update_attributes(:state => state,
                               :state_changed_at => state_changed_at)
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
