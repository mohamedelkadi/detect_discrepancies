require "bundler/setup"
require "bundler/setup"
require "detect_discrepancies"
require "detect_discrepancies/configuration"
require "detect_discrepancies/remote_campaign"
require "detect_discrepancies/remote_campaign"
require 'webmock/rspec'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
