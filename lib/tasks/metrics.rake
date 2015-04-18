namespace :metrics do
  desc 'Test for backfilling Mixpanel data points'
  task backfill_test: :environment do
    raise 'Only available in development' unless Rails.env.development?

    time = Time.now.pacific.nine_oclock
    user_id = 1337

    (1..7).each do |i|
      properties = {
        time: (time - i.days).to_i,
        user_id: user_id,
        pha_id: 1000 + i,
        test_id: 3,
        duration: 30 - i
      }

      tracker.import(api_key, user_id, 'Message Response', properties)
    end
  end

  def tracker
    @tracker ||= Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN'])
  end

  def api_key
    @api_key ||= ENV['MIXPANEL_API_KEY']
  end
end
