module GcpLlm
  class Client
    extend GcpLlm::HTTP

    def initialize(access_token: nil, organization_id: nil, uri_base: nil, request_timeout: nil)
      GcpLlm.configuration.access_token = access_token if access_token
      GcpLlm.configuration.organization_id = organization_id if organization_id
      GcpLlm.configuration.uri_base = uri_base if uri_base
      GcpLlm.configuration.request_timeout = request_timeout if request_timeout
    end

    def chat(parameters: {})
      GcpLlm::Client.json_post(path: "/chat/completions", parameters: parameters)
    end

    def completions(parameters: {})
      GcpLlm::Client.json_post(path: "/completions", parameters: parameters)
    end

    def edits(parameters: {})
      GcpLlm::Client.json_post(path: "/edits", parameters: parameters)
    end

    def embeddings(parameters: {})
      GcpLlm::Client.json_post(path: "/embeddings", parameters: parameters)
    end

    def files
      @files ||= GcpLlm::Files.new
    end

    def finetunes
      @finetunes ||= GcpLlm::Finetunes.new
    end

    def images
      @images ||= GcpLlm::Images.new
    end

    def models
      @models ||= GcpLlm::Models.new
    end

    def moderations(parameters: {})
      GcpLlm::Client.json_post(path: "/moderations", parameters: parameters)
    end

    def transcribe(parameters: {})
      GcpLlm::Client.multipart_post(path: "/audio/transcriptions", parameters: parameters)
    end

    def translate(parameters: {})
      GcpLlm::Client.multipart_post(path: "/audio/translations", parameters: parameters)
    end
  end
end
