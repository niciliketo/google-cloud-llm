RSpec.describe Google::Cloud::LLM do
  it "has a version number" do
    expect(Google::Cloud::LLM::VERSION).not_to be nil
  end

  describe "#configure" do
    let(:access_token) { "abc123" }
    let(:project_id) { "v2" }
    let(:api_endpoint) { "def456" }
    let(:model_id) { "ghi789" }
    let(:custom_uri_base) { "https://us-central1-aiplatform.googleapis.com" }
    let(:standard_uri_base) { "https://us-central1-aiplatform.googleapis.com/v1/projects/" }
    let(:custom_request_timeout) { 25 }

    before do
      Google::Cloud::LLM.configure do |config|
        config.access_token = access_token
        config.project_id = project_id
        # config.organization_id = organization_id
      end
    end

    it "returns the config" do
      expect(Google::Cloud::LLM.configuration.access_token).to eq(access_token)
      expect(Google::Cloud::LLM.configuration.project_id).to eq(project_id)
      expect(Google::Cloud::LLM.configuration.uri_base).to eq(standard_uri_base)
      expect(Google::Cloud::LLM.configuration.request_timeout).to eq(120)
    end

    context "without an access token" do
      let(:access_token) { nil }

      it "raises an error" do
        expect do
          Google::Cloud::LLM::Client.new.completions
        end.to raise_error(Google::Cloud::LLM::ConfigurationError)
      end
    end

    context "with custom timeout and uri base" do
      before do
        Google::Cloud::LLM.configure do |config|
          config.uri_base = custom_uri_base
          config.request_timeout = custom_request_timeout
        end
      end

      it "returns the config" do
        expect(Google::Cloud::LLM.configuration.access_token).to eq(access_token)
        # expect(Google::Cloud::LLM.configuration.api_version).to eq(api_version)
        expect(Google::Cloud::LLM.configuration.project_id).to eq(project_id)
        expect(Google::Cloud::LLM.configuration.uri_base).to eq(custom_uri_base)
        expect(Google::Cloud::LLM.configuration.request_timeout).to eq(custom_request_timeout)
      end

      after do
        Google::Cloud::LLM.configure do |config|
          config.uri_base = standard_uri_base
        end
      end
    end
  end
end
