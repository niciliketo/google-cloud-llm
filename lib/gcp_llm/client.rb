module GcpLlm
  class Client
    extend GcpLlm::HTTP

    def initialize(access_token: nil, project_id: nil, organization_id: nil, uri_base: nil,
                   request_timeout: nil)
      GcpLlm.configuration.access_token = access_token if access_token
      GcpLlm.configuration.project_id = project_id if project_id
      GcpLlm.configuration.organization_id = organization_id if organization_id
      GcpLlm.configuration.uri_base = uri_base if uri_base
      GcpLlm.configuration.request_timeout = request_timeout if request_timeout
    end

    def chat(parameters: {}, instances: {}, model: "chat-bison@001")
      final_params = { instances: instances,
                       parameters: GcpLlm.configuration.parameters.merge(parameters) }
      project_id = GcpLlm.configuration.project_id
      GcpLlm::Client.json_post(
        path: "/#{project_id}/locations/us-central1/publishers/google/models/#{model}:predict",
        parameters: final_params
      )
    end

    def completions(instances: [], parameters: {}, model: "text-bison@001")
      final_params = { instances: instances,
                       parameters: GcpLlm.configuration.parameters.merge(parameters) }
      project_id = GcpLlm.configuration.project_id
      GcpLlm::Client.json_post(
        path: "/#{project_id}/locations/us-central1/publishers/google/models/#{model}:predict",
        parameters: final_params
      )
    end

    def models
      @models ||= GcpLlm::Models.new
    end
  end
end
