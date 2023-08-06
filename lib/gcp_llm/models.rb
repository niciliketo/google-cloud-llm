module GcpLlm
  class Models
    # def initialize(access_token: nil, organization_id: nil)
    #   GcpLlm.configuration.access_token = access_token if access_token
    #   GcpLlm.configuration.organization_id = organization_id if organization_id
    # end
    MODEL_LIST = %w[text-bison text-bison@001 code-bison@001 code-gecko@001].freeze

    def list
      MODEL_LIST
    end

    # def retrieve(id:)
    #   GcpLlm::Client.get(path: "/models/#{id}")
    # end
  end
end
