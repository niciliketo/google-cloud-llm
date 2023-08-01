RSpec.describe GcpLlm do
  it "has a version number" do
    expect(GcpLlm::VERSION).not_to be nil
  end

  describe "#configure" do
    let(:access_token) { "abc123" }
    let(:api_version) { "v2" }
    let(:organization_id) { "def456" }
    let(:custom_uri_base) { "ghi789" }
    let(:custom_request_timeout) { 25 }

    before do
      GcpLlm.configure do |config|
        config.access_token = access_token
        config.api_version = api_version
        config.organization_id = organization_id
      end
    end

    it "returns the config" do
      expect(GcpLlm.configuration.access_token).to eq(access_token)
      expect(GcpLlm.configuration.api_version).to eq(api_version)
      expect(GcpLlm.configuration.organization_id).to eq(organization_id)
      expect(GcpLlm.configuration.uri_base).to eq("https://api.gcp_llm.com/")
      expect(GcpLlm.configuration.request_timeout).to eq(120)
    end

    context "without an access token" do
      let(:access_token) { nil }

      it "raises an error" do
        expect { GcpLlm::Client.new.completions }.to raise_error(GcpLlm::ConfigurationError)
      end
    end

    context "with custom timeout and uri base" do
      before do
        GcpLlm.configure do |config|
          config.uri_base = custom_uri_base
          config.request_timeout = custom_request_timeout
        end
      end

      it "returns the config" do
        expect(GcpLlm.configuration.access_token).to eq(access_token)
        expect(GcpLlm.configuration.api_version).to eq(api_version)
        expect(GcpLlm.configuration.organization_id).to eq(organization_id)
        expect(GcpLlm.configuration.uri_base).to eq(custom_uri_base)
        expect(GcpLlm.configuration.request_timeout).to eq(custom_request_timeout)
      end
    end
  end
end
