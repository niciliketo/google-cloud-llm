module GcpLlm
  class Client
    extend GcpLlm::HTTP

    def initialize(access_token: nil, project_id: nil, organization_id: nil, uri_base: nil, request_timeout: nil, parameters: nil)
      GcpLlm.configuration.access_token = access_token if access_token
      GcpLlm.configuration.project_id = project_id if project_id
      GcpLlm.configuration.organization_id = organization_id if organization_id
      GcpLlm.configuration.uri_base = uri_base if uri_base
      GcpLlm.configuration.request_timeout = request_timeout if request_timeout
      GcpLlm.configuration.request_timeout = parameters.merge(GcpLlm.configuration.parameters) if parameters
    end

    def chat(parameters: {}, instances: {})
      GcpLlm::Client.json_post(path: "/locations/us-central1/publishers/google/models/text-bison@001:predict", parameters:, instances:)
    end

    def completions(instances: [], parameters: {})
      final_params = {parameters:, instances:}
      GcpLlm::Client.json_post(path: "/#{GcpLlm.configuration.project_id}/locations/us-central1/publishers/google/models/text-bison@001:predict", parameters: final_params)
    end

    def models
      @models ||= GcpLlm::Models.new
    end
  end
end
