ON_CALL_START_HOUR = 7
ON_CALL_END_HOUR = 18
BusinessTime::Config.beginning_of_workday = "#{ON_CALL_START_HOUR}:00 am"
BusinessTime::Config.end_of_workday = "#{ON_CALL_END_HOUR % 12}:00 pm"
BusinessTime::Config.work_week = %i(mon tue wed thu fri)
