module Google
  module Cloud
    module LLM
      class Client
        extend Google::Cloud::LLM::HTTP

        def initialize(access_token: nil, project_id: nil, organization_id: nil, uri_base: nil,
                       request_timeout: nil)
          Google::Cloud::LLM.configuration.access_token = access_token if access_token
          Google::Cloud::LLM.configuration.project_id = project_id if project_id
          Google::Cloud::LLM.configuration.organization_id = organization_id if organization_id
          Google::Cloud::LLM.configuration.uri_base = uri_base if uri_base
          Google::Cloud::LLM.configuration.request_timeout = request_timeout if request_timeout
        end

        def chat(parameters: {}, instances: {}, model: "chat-bison@001")
          puts "parameters: #{parameters}"
          puts "LLM params: #{Google::Cloud::LLM.configuration.parameters}"
          final_params = { instances: instances,
                           parameters: Google::Cloud::LLM.configuration.parameters.merge(parameters) }
          project_id = Google::Cloud::LLM.configuration.project_id
          Google::Cloud::LLM::Client.json_post(
            path: "/#{project_id}/locations/us-central1/publishers/google/models/#{model}:predict",
            parameters: final_params
          )
        end

        def completions(instances: [], parameters: {}, model: "text-bison@001")
          final_params = { instances: instances,
                           parameters: Google::Cloud::LLM.configuration.parameters.merge(parameters) }
          project_id = Google::Cloud::LLM.configuration.project_id
          Google::Cloud::LLM::Client.json_post(
            path: "/#{project_id}/locations/us-central1/publishers/google/models/#{model}:predict",
            parameters: final_params
          )
        end

        def models
          @models ||= Google::Cloud::LLM::Models.new
        end
      end
    end
  end
end
