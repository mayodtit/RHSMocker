# Misha, 11/20/2013
#Delayed::Worker.delay_jobs = !Rails.env.test? # temporarily commenting out; causes test errors.  See Pivotal #61176198
Delayed::Worker.logger ||= Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
#
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 2
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.read_ahead = 10
#Delayed::Worker.default_queue_name = 'default'
