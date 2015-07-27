Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 3
Delayed::Worker.sleep_delay = 30
Delayed::Worker.delay_jobs = !Rails.env.test?
