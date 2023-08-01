module GcpLlm
  class Finetunes
    def initialize(access_token: nil, organization_id: nil)
      GcpLlm.configuration.access_token = access_token if access_token
      GcpLlm.configuration.organization_id = organization_id if organization_id
    end

    def list
      GcpLlm::Client.get(path: "/fine-tunes")
    end

    def create(parameters: {})
      GcpLlm::Client.json_post(path: "/fine-tunes", parameters: parameters)
    end

    def retrieve(id:)
      GcpLlm::Client.get(path: "/fine-tunes/#{id}")
    end

    def cancel(id:)
      GcpLlm::Client.multipart_post(path: "/fine-tunes/#{id}/cancel")
    end

    def events(id:)
      GcpLlm::Client.get(path: "/fine-tunes/#{id}/events")
    end

    def delete(fine_tuned_model:)
      if fine_tuned_model.start_with?("ft-")
        raise ArgumentError, "Please give a fine_tuned_model name, not a fine-tune ID"
      end

      GcpLlm::Client.delete(path: "/models/#{fine_tuned_model}")
    end
  end
end
