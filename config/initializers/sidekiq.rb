require 'sidekiq'
require 'sidekiq-scheduler'
require 'sidekiq-scheduler/web'

Sidekiq.configure_server do |config|
  schedule_file = "config/sidekiq.yml"

  if File.exist?(schedule_file)
    Sidekiq::Scheduler.dynamic = true
    config.on(:startup) do
      Sidekiq::Scheduler.reload_schedule!
    end
    Sidekiq::Scheduler.load_schedule!
  end
end
