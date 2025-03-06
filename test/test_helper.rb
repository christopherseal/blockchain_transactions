ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "database_cleaner/active_record"

DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase
  setup { DatabaseCleaner.start }
  teardown { DatabaseCleaner.clean }
end

require "sidekiq/testing"
Sidekiq::Testing.inline!

Minitest::Test.make_my_diffs_pretty!
