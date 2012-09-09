config_file = File.join(Rails.root, 'config', 'sidekiq.yml')
raise "#{config_file} is missing!" unless File.exists? config_file

Steamboat::Application.configure do
  APP_CONFIG ||= {}
  APP_CONFIG[:sidekiq] = YAML.load_file(config_file)[Rails.env].symbolize_keys
end

Sidekiq.configure_server do |config|
  config.redis = APP_CONFIG[:sidekiq][:server].symbolize_keys
end

Sidekiq.configure_client do |config|
  config.redis = APP_CONFIG[:sidekiq][:client].symbolize_keys
end