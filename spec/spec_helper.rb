require "bundler/setup"
require "dotenv/load"
require "gcp_llm"
require "gcp_llm/compatibility"
require "vcr"

Dir[File.expand_path("spec/support/**/*.rb")].sort.each { |f| require f }

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = "spec/fixtures/cassettes"
  c.default_cassette_options = {
    record: ENV.fetch("GCP_ACCESS_TOKEN", nil) ? :all : :new_episodes,
    match_requests_on: [:method, :uri, VCRMultipartMatcher.new]
  }
  c.filter_sensitive_data("<GCP_ACCESS_TOKEN>") { GcpLlm.configuration.access_token }
  c.filter_sensitive_data("<GCP_PROJECT_ID>") { GcpLlm.configuration.project_id }
end

RSpec.configure do |c|
  # Enable flags like --only-failures and --next-failure
  c.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  c.disable_monkey_patching!

  c.expect_with :rspec do |rspec|
    rspec.syntax = :expect
  end

  if ENV.fetch("GCP_ACCESS_TOKEN", nil)
    warning = "WARNING! Specs are hitting the GcpLlm API using your GCP_ACCESS_TOKEN! This
costs at least 2 cents per run and is very slow! If you don't want this, unset
GCP_ACCESS_TOKEN to just run against the stored VCR responses.".freeze
    warning = RSpec::Core::Formatters::ConsoleCodes.wrap(warning, :bold_red)

    c.before(:suite) { RSpec.configuration.reporter.message(warning) }
    c.after(:suite) { RSpec.configuration.reporter.message(warning) }
  end

  if ENV.fetch("GCP_PROJECT_ID", nil)
    warning = "WARNING! Specs are hitting the GcpLlm API using your GCP_PROJECT_ID! This
costs at least 2 cents per run and is very slow! If you don't want this, unset
GCP_PROJECT_ID to just run against the stored VCR responses.".freeze
    warning = RSpec::Core::Formatters::ConsoleCodes.wrap(warning, :bold_red)

    c.before(:suite) { RSpec.configuration.reporter.message(warning) }
    c.after(:suite) { RSpec.configuration.reporter.message(warning) }
  end

  c.before(:all) do
    GcpLlm.configure do |config|
      config.access_token = ENV.fetch("GCP_ACCESS_TOKEN", "dummy-token")
      config.project_id = ENV.fetch("GCP_PROJECT_ID", "dummy-project-id")
    end
  end
end

RSPEC_ROOT = File.dirname __FILE__
