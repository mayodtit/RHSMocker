namespace :user_change do
  desc "Convert user changes with strings to hashes"
  task :convert_user_changes_with_string_to_hash => :environment do
    with_string = UserChange.where 'data IS NOT NULL AND data NOT LIKE "--- %"'
    puts "Converting #{with_string.count} old user changes"
    with_string.find_each do |user_change|
      next unless user_change.data.is_a? String
      # Convert timestamps to valid ruby (e.g. Time.parse("[TIMESTAMP]"))
      converted_data = user_change.data.gsub(/([a-zA-z][a-zA-z][a-zA-z], \d\d [a-zA-z][a-zA-z][a-zA-z] \d\d\d\d \d\d:\d\d:\d\d [a-zA-z][a-zA-z][a-zA-z] \+\d\d:\d\d)/, 'Time.parse("\1")')
      user_change.data = eval converted_data
      user_change.save!
    end
  end
end