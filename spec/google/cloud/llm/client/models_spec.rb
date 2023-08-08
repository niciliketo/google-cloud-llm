RSpec.describe Google::Cloud::LLM::Client do
  describe "#models" do
    describe "#list", :vcr do
      let(:response) { Google::Cloud::LLM::Client.new.models.list }
      let(:cassette) { "models list" }

      it "succeeds" do
        expect(response.class).to eq(Array)
      end
    end
  end
end
