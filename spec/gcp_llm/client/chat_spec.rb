RSpec.describe GcpLlm::Client do
  describe "#chat" do
    context "with messages", :vcr do
      let(:messages) { [{ role: "user", content: "Hello!" }] }
      let(:stream) { false }
      let(:response) do
        GcpLlm::Client.new.chat(
          instances: [
            {
              context: "You are a helpful assistant",
              examples: [],
              messages: [
                {
                  author: "user",
                  content: "What is the capital of France"
                },
                {
                  content: "Paris is the capital and largest city of France.",
                  author: "bot",
                  citationMetadata: {
                    citations: []
                  }
                },
                {
                  author: "user",
                  content: "What is the capital of Italy"
                }
              ]
            }
          ]
        )
      end
      let(:content) { response.dig("predictions", 0, "candidates", 0, "content") }
      let(:cassette) { "#{model} #{'streamed' if stream} chat".downcase }

      context "with model: chat-bison@001" do
        let(:model) { "chat-bison@001" }

        it "succeeds" do
          VCR.use_cassette(cassette) do
            expect(content.split.empty?).to eq(false)
          end
        end

        # describe "streaming" do
        #   let(:chunks) { [] }
        #   let(:stream) do
        #     proc do |chunk, _bytesize|
        #       chunks << chunk
        #     end
        #   end

        #   it "succeeds" do
        #     VCR.use_cassette(cassette) do
        #       response
        #       expect(chunks.dig(0, "choices", 0, "index")).to eq(0)
        #     end
        #   end

        #   context "with an object with a call method" do
        #     let(:cassette) { "#{model} streamed chat without proc".downcase }
        #     let(:stream) do
        #       Class.new do
        #         attr_reader :chunks

        #         def initialize
        #           @chunks = []
        #         end

        #         def call(chunk)
        #           @chunks << chunk
        #         end
        #       end.new
        #     end

        #     it "succeeds" do
        #       VCR.use_cassette(cassette) do
        #         response
        #         expect(stream.chunks.dig(0, "choices", 0, "index")).to eq(0)
        #       end
        #     end
        #   end

        #   context "with an object without a call method" do
        #     let(:stream) { Object.new }

        #     it "raises an error" do
        #       VCR.use_cassette(cassette) do
        #         expect { response }.to raise_error(ArgumentError)
        #       end
        #     end
        #   end
        # end
      end

      context "with model: codechat-bison@001" do
        let(:model) { "codechat-bison@001" }

        it "succeeds" do
          VCR.use_cassette(cassette) do
            expect(content.split.empty?).to eq(false)
          end
        end
      end
    end
  end
end
