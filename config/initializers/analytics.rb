# default token is for rhs-devlocal
mixpanel_token = ENV['MIXPANEL_TOKEN'] || '0be4238ea000ed81ed667a479be4e7c4'
MIXPANEL = Mixpanel::Tracker.new(mixpanel_token)