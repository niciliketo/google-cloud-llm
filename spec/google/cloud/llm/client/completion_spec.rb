RSpec.describe Google::Cloud::LLM::Client do
  describe "#completions: Vertex models" do
    context "with a prompt and max_tokens", :vcr do
      let(:prompt) { "Once upon a time" }
      let(:max_tokens) { 5 }

      let(:response) do
        Google::Cloud::LLM::Client.new.completions(
          instances: [
            {
              content: prompt
            }
          ],
          parameters: {
            maxOutputTokens: max_tokens
          },
          model: model
        )
      end
      let(:text) { response.dig("predictions", 0, "content") }
      let(:cassette) { "#{model} completions #{prompt}".downcase }

      context "with model: text-bison@001" do
        let(:model) { "text-bison@001" }

        it "succeeds" do
          VCR.use_cassette(cassette) do
            expect(text.split.empty?).to eq(false)
          end
        end
      end
    end
  end
end
