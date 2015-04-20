namespace :metrics do
  desc 'Backfill Message Response events'
  task :backfill_message_response_events, [:start_at, :end_at, :dry_run, :mixpanel_token, :mixpanel_api_key] => [:environment] do |t, args|
    options = {}.tap do |opts|
      opts[:start_at] = Time.parse(args[:start_at]) if args[:start_at]
      opts[:end_at] = Time.parse(args[:end_at]) if args[:end_at]
      opts[:dry_run] = true if args[:dry_run] == 'true'
      opts[:mixpanel_token] = args[:mixpanel_token] if args[:mixpanel_token]
      opts[:mixpanel_api_key] = args[:mixpanel_api_key] if args[:mixpanel_api_key]
      opts[:debug] = true
    end

    Metrics.instance.configure(options)
    Metrics.instance.reload!
    results = Metrics.instance.backfill_message_response_events
    puts "Imported #{results[:imported_event_count]} events"
    puts "Found #{results[:needs_response].count} messages that need response"
    if results[:needs_response].any?
      puts "The users with the following ids require a response:"
      puts "[#{results[:needs_response].map(&:user_id).join(',')}]"
    end
  end
end
