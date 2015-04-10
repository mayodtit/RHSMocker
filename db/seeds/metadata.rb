[
  {key: 'allow_tos_checked', value: 'false'},
  {key: 'pha_phone_number', value: '5555555555'},
  {key: 'nurse_phone_number', value: '5551112222'},
  {key: 'outbound_calls_number', value: '5555555556'},
  {key: 'remove_robot_response', value: 'true'},
  {key: 'version', value: '1.0.5'},
  {key: 'android_version', value: '0.0.1'},
  {key: 'app_store_url', value: 'http://www.getbetter.com/app'},
  {key: 'google_play_url', value: 'https://play.google.com/store/apps/details?id=com.getbetter'},
  {key: 'use_pub_sub', value: 'true'},
  {key: 'enable_pha_phone_queue', value: 'true'},
  {key: 'direct_nurse_phone_number', value: '5553334444'},
  {key: 'force_phas_off_call', value: 'false'},
  {key: 'enable_sharing', value: 'true'},
  {key: 'signup_free_trial', value: 'false'},
  {key: 'new_onboarding_flow', value: 'true'},
  {key: 'offboard_free_trial_members', value: 'true'},
  {key: 'automated_onboarding', value: 'true'},
  {key: 'automated_offboarding', value: 'true'},
  {key: 'notify_lack_of_tasks', value: 'true'},
  {key: 'notify_lack_of_messages', value: 'true'}
].each do |hash|
  Metadata.upsert_attributes({mkey: hash[:key]}, {mvalue: hash[:value]})
end
