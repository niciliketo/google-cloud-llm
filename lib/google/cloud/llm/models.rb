module Google
  module Cloud
    module LLM
      class Models
        # def initialize(access_token: nil, organization_id: nil)
        #   Google::Cloud::LLM.configuration.access_token = access_token if access_token
        #   Google::Cloud::LLM.configuration.organization_id = organization_id if organization_id
        # end
        MODEL_LIST = %w[text-bison text-bison@001 code-bison@001 code-gecko@001].freeze

        def list
          MODEL_LIST
        end

        # def retrieve(id:)
        #   Google::Cloud::LLM::Client.get(path: "/models/#{id}")
        # end
      end
    end
  end
end
