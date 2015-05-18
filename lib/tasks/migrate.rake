namespace :migrate do
  task cache_session_info_on_user: :environment do
    Member.joins(:sessions).update_all('users.time_zone = sessions.device_timezone')
    Member.joins(:sessions).update_all('users.cached_notifications_enabled = sessions.device_notifications_enabled')
  end

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

  task :update_allergies_question_resource do
    content = Content.find_by_title!('Your Allergies')
    question = Question.find_by_view!(:allergies)
    Card.where(:resource_id => content.id,
               :resource_type => 'Content').find_each do |c|
      if c.update_attributes(:resource => question)
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

  task :backfill_enrollments => :environment do
    Enrollment.where('email IS NOT NULL')
              .where(user_id: nil)
              .find_each do |enrollment|
      if member = Member.find_by_email(enrollment.email)
        enrollment.update_attributes!(user: member)
        print '.'
      else
        print '*'
      end
    end
  end

  task :update_member_task_priority => :environment do
    MemberTask.open_state.each {|task|
      task.priority = 3
      task.save
    }
  end

  task :fix_markdown_links, [:dry_run] => :environment do |t, args|
    dry_run = args[:dry_run] != 'false'

    puts 'Dry run! Not committing any changes!' if dry_run

    broken_messages = Message.with_bad_markdown_links

    puts "Fixing #{pluralize(broken_messages.length, 'message')}."

    broken_messages.each do |m|
      m.fix_bad_markdown_links! unless dry_run
      print '.'
    end

    members = Member.joins(:master_consult).where(consults: {id: broken_messages.map(&:consult_id)})

    puts "\nLogging out #{pluralize(members.length, 'user')}."

    members.each do |member|
      member.sessions.destroy_all unless dry_run
      print "."
    end

    puts "\nAll done!"
  end

  desc "Backfill BMI."
  task :backfill_bmi => :environment do
    Weight.where(bmi: nil).each{|w| w.save!}
  end

  def pluralize(count, singular)
    ActionController::Base.helpers.pluralize(count, singular)
  end

  desc 'Apply #super_titleize to all Allergy names'
  task titleize_allergies: :environment do
    Allergy.find_each do |allergy|
      allergy.update_attributes(name: allergy.name.super_titleize,
                                skip_reindex: true)
    end
    Allergy.reindex
  end

  desc 'Apply #super_titleize to all Condition names'
  task titleize_conditions: :environment do
    Condition.find_each do |condition|
      condition.update_attributes(name: condition.name.super_titleize,
                                  skip_reindex: true)
    end
    Condition.reindex
  end

  desc 'Deduplicate Allergy records with the same names'
  task deduplicate_allergies: :environment do
    Allergy.deduplicate_names!
  end
end
