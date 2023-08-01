RSpec.describe "compatibility" do
  context "for moved constants" do
    describe "::Ruby::GcpLlm::VERSION" do
      it "is mapped to ::GcpLlm::VERSION" do
        expect(Ruby::GcpLlm::VERSION).to eq(GcpLlm::VERSION)
      end
    end

    describe "::Ruby::GcpLlm::Error" do
      it "is mapped to ::GcpLlm::Error" do
        expect(Ruby::GcpLlm::Error).to eq(GcpLlm::Error)
        expect(Ruby::GcpLlm::Error.new).to be_a(GcpLlm::Error)
        expect(GcpLlm::Error.new).to be_a(Ruby::GcpLlm::Error)
      end
    end

    describe "::Ruby::GcpLlm::ConfigurationError" do
      it "is mapped to ::GcpLlm::ConfigurationError" do
        expect(Ruby::GcpLlm::ConfigurationError).to eq(GcpLlm::ConfigurationError)
        expect(Ruby::GcpLlm::ConfigurationError.new).to be_a(GcpLlm::ConfigurationError)
        expect(GcpLlm::ConfigurationError.new).to be_a(Ruby::GcpLlm::ConfigurationError)
      end
    end

    describe "::Ruby::GcpLlm::Configuration" do
      it "is mapped to ::GcpLlm::Configuration" do
        expect(Ruby::GcpLlm::Configuration).to eq(GcpLlm::Configuration)
        expect(Ruby::GcpLlm::Configuration.new).to be_a(GcpLlm::Configuration)
        expect(GcpLlm::Configuration.new).to be_a(Ruby::GcpLlm::Configuration)
      end
    end
  end
end
