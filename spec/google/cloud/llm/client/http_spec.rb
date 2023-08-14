RSpec.describe Google::Cloud::LLM::HTTP do
  describe "with an aggressive timeout" do
    let(:timeout_errors) { [Faraday::ConnectionFailed, Faraday::TimeoutError] }
    let(:timeout) { 0 }

    # We disable VCR and WebMock for timeout specs, otherwise VCR will return instant
    # responses when using the recorded responses and the specs will fail incorrectly.
    before do
      VCR.turn_off!
      WebMock.allow_net_connect!
      Google::Cloud::LLM.configuration.request_timeout = timeout
    end

    after do
      VCR.turn_on!
      WebMock.disable_net_connect!
      Google::Cloud::LLM.configuration.request_timeout = Google::Cloud::LLM::Configuration::DEFAULT_REQUEST_TIMEOUT
    end

    describe ".get" do
      let(:response) do
        Google::Cloud::LLM::Client.new.completions(instances: [{ content: "Once upon a time" }])
      end
      it "times out" do
        expect { response }.to raise_error do |error|
          expect(timeout_errors).to include(error.class)
        end
      end
    end

    describe ".json_post" do
      let(:response) do
        Google::Cloud::LLM::Client.new.completions(instances: [{ content: "Once upon a time" }])
      end

      context "not streaming" do
        # let(:stream) { false }

        it "times out" do
          expect { response }.to raise_error do |error|
            expect(timeout_errors).to include(error.class)
          end
        end
      end

      #   context "streaming" do
      #     let(:chunks) { [] }
      #     let(:stream) do
      #       proc do |chunk, _bytesize|
      #         chunks << chunk
      #       end
      #     end

      #     it "times out" do
      #       expect { response }.to raise_error do |error|
      #         expect(timeout_errors).to include(error.class)
      #       end
      #     end
      #   end
    end
  end

  describe ".to_json_stream" do
    context "with a proc" do
      let(:user_proc) { proc { |x| x } }
      let(:stream) { Google::Cloud::LLM::Client.send(:to_json_stream, user_proc: user_proc) }

      it "returns a proc" do
        expect(stream).to be_a(Proc)
      end

      context "when called with a string containing a single JSON object" do
        it "calls the user proc with the data parsed as JSON" do
          expect(user_proc).to receive(:call).with(JSON.parse('{"foo": "bar"}'))
          stream.call('data: { "foo": "bar" }')
        end
      end

      context "when called with string containing more than one JSON object" do
        it "calls the user proc for each data parsed as JSON" do
          expect(user_proc).to receive(:call).with(JSON.parse('{"foo": "bar"}'))
          expect(user_proc).to receive(:call).with(JSON.parse('{"baz": "qud"}'))

          stream.call(<<-CHUNK)
            data: { "foo": "bar" }

            data: { "baz": "qud" }

            data: [DONE]

          CHUNK
        end
      end

      context "when called with a string that does not even resemble a JSON object" do
        let(:bad_examples) { ["", "foo", "data: ", "data: foo"] }

        it "does not call the user proc" do
          bad_examples.each do |chunk|
            expect(user_proc).to_not receive(:call)
            stream.call(chunk)
          end
        end
      end

      context "when called with a string containing that looks like a JSON object but is invalid" do
        let(:chunk) do
          <<-CHUNK
            data: { "foo": "bar" }
            data: { BAD ]:-> JSON }
          CHUNK
        end

        it "does not raise an error" do
          expect(user_proc).to receive(:call).with(JSON.parse('{"foo": "bar"}'))

          expect do
            stream.call(chunk)
          end.not_to raise_error
        end
      end

      context "when called with a string containing an error" do
        let(:chunk) do
          <<-CHUNK
            data: { "foo": "bar" }
            error: { "message": "A bad thing has happened!" }
          CHUNK
        end

        it "does not raise an error" do
          expect(user_proc).to receive(:call).with(JSON.parse('{ "foo": "bar" }'))
          expect(user_proc).to receive(:call).with(
            JSON.parse('{ "message": "A bad thing has happened!" }')
          )

          expect do
            stream.call(chunk)
          end.not_to raise_error
        end
      end
    end
  end

  describe ".to_json" do
    context "with a jsonl string" do
      let(:body) { "{\"prompt\":\":)\"}\n{\"prompt\":\":(\"}\n" }
      let(:parsed) { Google::Cloud::LLM::Client.send(:to_json, body) }

      it { expect(parsed).to eq([{ "prompt" => ":)" }, { "prompt" => ":(" }]) }
    end
  end

  describe ".uri" do
    let(:path) { "/chat" }
    let(:uri) { Google::Cloud::LLM::Client.send(:uri, path: path) }

    it { expect(uri).to eq("https://us-central1-aiplatform.googleapis.com/v1/projects/chat") }

    context "uri_base without trailing slash" do
      before do
        Google::Cloud::LLM.configuration.uri_base = "https://us-central1-aiplatform.googleapis.com/v1/projects"
      end

      after do
        Google::Cloud::LLM.configuration.uri_base = "https://us-central1-aiplatform.googleapis.com/v1/projects/"
      end

      it { expect(uri).to eq("https://us-central1-aiplatform.googleapis.com/v1/projects/chat") }
    end
  end

  describe ".headers" do
    let(:headers) { Google::Cloud::LLM::Client.send(:headers) }

    it {
      expect(headers).to eq(Google::Cloud::LLM.configuration.access_token_header
                                              .merge("Content-Type" => "application/json"))
    }
  end
end
