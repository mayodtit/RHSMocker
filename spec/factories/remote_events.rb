FactoryGirl.define do
  factory :remote_event do
    sequence(:name) {|n| "RemoteEvent #{n}"}
    sequence(:device_created_at)
    device_language 'en'
    device_os 'iOS'
    device_os_version '0.26-1'
    device_model 'Simulator'
    sequence(:device_timezone_offset)
    app_version '1'
    app_build '6.1'
  end
end
