RSpec.describe "compatibility" do
  context "for moved constants" do
    describe "::Google::Cloud::LLM::VERSION" do
      it "is mapped to ::Google::Cloud::LLM::VERSION" do
        expect(Google::Cloud::LLM::VERSION).to eq(Google::Cloud::LLM::VERSION)
      end
    end

    describe "::Google::Cloud::LLM::Error" do
      it "is mapped to ::Google::Cloud::LLM::Error" do
        expect(Google::Cloud::LLM::Error).to eq(Google::Cloud::LLM::Error)
        expect(Google::Cloud::LLM::Error.new).to be_a(Google::Cloud::LLM::Error)
        expect(Google::Cloud::LLM::Error.new).to be_a(Google::Cloud::LLM::Error)
      end
    end

    describe "::Google::Cloud::LLM::ConfigurationError" do
      it "is mapped to ::Google::Cloud::LLM::ConfigurationError" do
        expect(Google::Cloud::LLM::ConfigurationError).to eq(Google::Cloud::LLM::ConfigurationError)
        expect(Google::Cloud::LLM::ConfigurationError.new).to be_a(Google::Cloud::LLM::ConfigurationError)
        expect(Google::Cloud::LLM::ConfigurationError.new).to be_a(Google::Cloud::LLM::ConfigurationError)
      end
    end

    describe "::Google::Cloud::LLM::Configuration" do
      it "is mapped to ::Google::Cloud::LLM::Configuration" do
        expect(Google::Cloud::LLM::Configuration).to eq(Google::Cloud::LLM::Configuration)
        expect(Google::Cloud::LLM::Configuration.new).to be_a(Google::Cloud::LLM::Configuration)
        expect(Google::Cloud::LLM::Configuration.new).to be_a(Google::Cloud::LLM::Configuration)
      end
    end
  end
end
