require "faraday"
require "faraday/multipart"

require_relative "gcp_llm/http"
require_relative "gcp_llm/client"
# require_relative "gcp_llm/files"
# require_relative "gcp_llm/finetunes"
# require_relative "gcp_llm/images"
# require_relative "gcp_llm/models"
# require_relative "gcp_llm/version"

module GcpLlm
  class Error < StandardError; end
  class ConfigurationError < Error; end

  class Configuration
    attr_writer :access_token
    # attr_accessor :api_type, :api_version, :organization_id, :uri_base
    attr_accessor :api_endpoint, :project_id, :model_id, :uri_base, :request_timeout

    # DEFAULT_API_VERSION = "v1".freeze
    DEFAULT_URI_BASE = "https://us-central1-aiplatform.googleapis.com/v1/projects/".freeze
    DEFAULT_REQUEST_TIMEOUT = 120

    def initialize
      @access_token = nil
      @api_type = nil
      @organization_id = nil
      @uri_base = DEFAULT_URI_BASE
      @request_timeout = DEFAULT_REQUEST_TIMEOUT
    end

    def access_token
      return @access_token if @access_token

      error_text = "GcpLlm access token missing! See https://github.com/alexrudall/ruby-gcp-llm#usage"
      # raise ConfigurationError, error_text
    end

    def uri
      # "https://%{@api_endpoint}/v1/projects/%{@project_id}/locations/us-central1/publishers/google/models/%{model_id}:predict"
      "https://us-central1-aiplatform.googleapis.com/v1/projects/ai-test-project-389008/locations/us-central1/publishers/google/models/text-bison@001:predict"
    end
  end

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= GcpLlm::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
