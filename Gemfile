source "https://rubygems.org"

ruby "3.4.2"

gem "rails", "~> 8.0.2"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"

gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

gem "dotenv"
gem "deep_merge" # mostly for testing
gem "faraday"
gem "jsbundling-rails"
gem "jwt"
gem "propshaft"
gem "redis"
gem "rswag"

group :production do
  gem "pg"
end

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "pry-rails"
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "annotaterb"
end

group :test do
  gem "factory_bot_rails"
  gem "faker"
  gem "mock_redis"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 8.0.2"
  gem "shoulda-matchers", "~> 6.5"
  gem "simplecov"
  gem "timecop"
  gem "webmock"
end
