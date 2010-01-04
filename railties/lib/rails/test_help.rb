# Make double-sure the RAILS_ENV is set to test,
# so fixtures are loaded to the right database
silence_warnings { RAILS_ENV = "test" }

require 'rack'
require 'rack/test'

require 'test/unit'
require 'active_support/core_ext/kernel/requires'

if defined?(ActiveRecord)
  class ActiveSupport::TestCase
    include ActiveRecord::TestFixtures
    self.fixture_path = "#{Rails.root}/test/fixtures/"
    self.use_instantiated_fixtures  = false
    self.use_transactional_fixtures = true
  end

  ActionController::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path

  def create_fixtures(*table_names, &block)
    Fixtures.create_fixtures(ActiveSupport::TestCase.fixture_path, table_names, {}, &block)
  end
end

begin
  require_library_or_gem 'ruby-debug'
  Debugger.start
  if Debugger.respond_to?(:settings)
    Debugger.settings[:autoeval] = true
    Debugger.settings[:autolist] = 1
  end
rescue LoadError
  # ruby-debug wasn't available so neither can the debugging be
end
