require "faraday"
require "faraday/multipart"

require_relative "llm/http"
require_relative "llm/client"
# require_relative "gcp_llm/files"
# require_relative "gcp_llm/finetunes"
# require_relative "gcp_llm/images"
require_relative "llm/models"
# TODO: fix
# require_relative "gcp_llm/version"

module Google
  module Cloud
    module LLM
      class Error < StandardError; end
      class ConfigurationError < Error; end

      class Configuration
        attr_writer :access_token, :project_id
        # attr_accessor :api_type, :api_version, :organization_id, :uri_base
        attr_accessor :api_endpoint, :model_id, :uri_base, :request_timeout, :parameters

        # DEFAULT_API_VERSION = "v1".freeze
        DEFAULT_URI_BASE = "https://us-central1-aiplatform.googleapis.com/v1/projects/".freeze
        DEFAULT_REQUEST_TIMEOUT = 120
        DEFAULT_PARAMETERS = {
          temperature: 0.2,
          topP: 0.8,
          topK: 40,
          maxOutputTokens: 256
        }.freeze

        def initialize
          @access_token = nil
          @api_type = nil
          @organization_id = nil
          @uri_base = DEFAULT_URI_BASE
          @request_timeout = DEFAULT_REQUEST_TIMEOUT
          @project_id = nil
          @parameters = DEFAULT_PARAMETERS
        end

        def access_token
          return @access_token if @access_token

          error_text = "Google::Cloud::LLM access token missing! See https://github.com/alexrudall/ruby-gcp-llm#usage"
          raise ConfigurationError, error_text
        end

        def project_id
          return @project_id if @project_id

          error_text = "Google::Cloud::LLM project_id missing! See https://github.com/alexrudall/ruby-gcp-llm#usage"
          raise ConfigurationError, error_text
        end

        def uri
          # "https://%{@api_endpoint}/v1/projects/%{@project_id}/locations/us-central1/publishers/google/models/%{model_id}:predict"
          "#{@uri_base}/#{project_id}/locations/us-central1/publishers/google/models/text-bison@001:predict"
        end
      end

      class << self
        attr_writer :configuration
      end

      def self.configuration
        @configuration ||= Google::Cloud::LLM::Configuration.new
      end

      def self.configure
        yield(configuration)
      end
    end
  end
end