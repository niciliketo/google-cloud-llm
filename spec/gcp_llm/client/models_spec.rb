RSpec.describe GcpLlm::Client do
  describe "#models" do
    describe "#list", :vcr do
      let(:response) { GcpLlm::Client.new.models.list }
      let(:cassette) { "models list" }

      it "succeeds" do
        expect(response.class).to eq(Array)
      end
    end
  end
end
