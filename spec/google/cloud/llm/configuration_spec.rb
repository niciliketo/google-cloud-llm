RSpec.describe Google::Cloud::LLM::Configuration do
  subject { described_class.new }

  describe "#project_id" do
    let(:config) { Google::Cloud::LLM::Configuration.new }
    let(:fake_google_auth) { double("Google::Auth", project_id: fake_google_auth_project_id) }
    let(:fake_google_auth_project_id) { "auth_project_id" }

    before do
      # Stubbing external dependencies
      allow(Google::Auth).to receive(:get_application_default).and_return(fake_google_auth)
      allow(Google::Cloud.env).to receive(:project_id).and_return(nil) # Default to nil
    end

    context "when @project_id is set" do
      it "returns @project_id" do
        subject.project_id = "explicit_project_id"
        expect(subject.project_id).to eq("explicit_project_id")
      end
    end

    context "when google_auth has a project_id" do
      it "returns the google_auth project_id" do
        expect(subject.project_id).to eq("auth_project_id")
      end
    end

    context "when Google::Cloud.env.project_id is present" do
      let(:fake_google_auth_project_id) { nil }

      before do
        allow(Google::Cloud.env).to receive(:project_id).and_return("cloud_env_project_id")
      end

      it "returns the Google::Cloud.env.project_id" do
        expect(subject.project_id).to eq("cloud_env_project_id")
      end
    end

    context "when no project_id is available" do
      let(:fake_google_auth) { double("Google::Auth", project_id: nil) }
      before do
        allow(Google::Cloud.env).to receive(:project_id).and_return(nil)
      end

      it "raises a ConfigurationError" do
        expect { subject.project_id }.to raise_error(Google::Cloud::LLM::ConfigurationError)
      end
    end
  end
end
