acllm-experiment branch
# Ruby GCP LLM

[![Gem Version](https://badge.fury.io/rb/ruby-gcp-llm.svg)](https://badge.fury.io/rb/ruby-gcp-llm)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/niciliketo/google-cloud-llm/blob/main/LICENSE.txt)
[![GitHub Build Status](https://github.com/niciliketo/google-cloud-llm/actions/workflows/ruby.yml/badge.svg)

Use the [Google::Cloud::LLM API](https://gcp_llm.com/blog/gcp_llm-api/) with Ruby! 🤖❤️

### Credits

This library is heavily based on https://github.com/alexrudall/ruby-openai/ and the intention is to provide a similar interface to the one provided by that library.

### Bundler

Add this line to your application's Gemfile:

```ruby
gem "google-cloud-llm"
```

And then execute:

$ bundle install

### Gem install

Or install with:

$ gem install ruby-gcp-llm

and require with:

```ruby
require 'google/cloud/llm'
```

## Usage

- Get your configuration from [https://console.cloud.google.com/vertex-ai/generative/language/create/text](https://console.cloud.google.com/vertex-ai/generative/language/create/text)
- You will need:
  - ACCESS_TOKEN
  - PROJECT_ID
- You can also configure:
  - API_ENDPOINT
  - MODEL_ID


### Quickstart

For a quick test you can pass your token directly to a new client:

```ruby
client = Google::Cloud::LLM::Client.new(access_token: "access_token_goes_here", project_id: "project_id_goes_here")
```

### With Config

For a more robust setup, you can configure the gem with your API keys, for example in an `gcp_llm.rb` initializer file. Never hardcode secrets into your codebase - instead use something like [dotenv](https://github.com/motdotla/dotenv) to pass the keys safely into your environments.

```ruby
Google::Cloud::LLM.configure do |config|
    config.access_token = ENV.fetch("GCP_LLM_ACCESS_TOKEN")
    config.project_id = ENV.fetch("GCP_LLM_PROJECT_ID")
    config.api_endpoint = ENV.fetch("GCP_LLM_API_ENDPOINT")
    config.model_id = ENV.fetch("GCP_LLM_MODEL_ID") # optional
end
```

Then you can create a client like this:

```ruby
client = Google::Cloud::LLM::Client.new
```

#### Custom timeout or base URI

The default timeout for any request using this library is 120 seconds. You can change that by passing a number of seconds to the `request_timeout` when initializing the client. You can also change the base URI used for all requests, eg. to use observability tools like [Helicone](https://docs.helicone.ai/quickstart/integrate-in-one-line-of-code):

```ruby
client = Google::Cloud::LLM::Client.new(
    access_token: "access_token_goes_here",
    project_id: "project_id_goes_here")
    request_timeout: 240
)
```

or when configuring the gem:

```ruby
Google::Cloud::LLM.configure do |config|
    config.access_token = ENV.fetch("GCP_LLM_ACCESS_TOKEN")
    config.project_id = ENV.fetch("GCP_LLM_PROJECT_ID")
    config.api_endpoint = ENV.fetch("GCP_LLM_API_ENDPOINT")
    config.model_id = ENV.fetch("GCP_LLM_MODEL_ID") # optional
    config.request_timeout = 240 # Optional
end
```

### TODO: Models

There are different models that can be used to generate text. For a full list and to retrieve information about a single model:

```ruby
client.models.list
client.models.retrieve(id: "text-ada-001")
```

#### TODO: Examples

- [GPT-4 (limited beta)](https://platform.gcp_llm.com/docs/models/gpt-4)
  - gpt-4
  - gpt-4-0314
  - gpt-4-32k
- [GPT-3.5](https://platform.gcp_llm.com/docs/models/gpt-3-5)
  - gpt-3.5-turbo
  - gpt-3.5-turbo-0301
  - text-davinci-003
- [GPT-3](https://platform.gcp_llm.com/docs/models/gpt-3)
  - text-ada-001
  - text-babbage-001
  - text-curie-001

### Completion

Completion is a model that can be used to generate text to complete a prompt. You can use it to [generate a content](https://cloud.google.com/vertex-ai/docs/generative-ai/language-model-overview):

```ruby
response = client.completions(
          instances: [
            {
              content: 'Once upon a time'
            }
          ])

puts response.dig("predictions", 0, "content")
# => ", there was a little girl who lived in a small village...."

response = client.completions(
          instances: [
            {
              content: 'Once upon a time'
            }
          ],
          parameters: {
            maxOutputTokens: 5
          },
          model: 'text-bison')

puts response.dig("predictions", 0, "content")
# => ", there was a little"
```

### Chat

ChatGPT is a model that can be used to generate text in a conversational style. You can use it to [generate a response](https://cloud.google.com/vertex-ai/docs/generative-ai/language-model-overview):

```ruby
response = client.chat(
              instances: [
            {
              context: "You are a helpful assistant",
              examples: [],
              messages: [
                {
                  author: "user",
                  content: "What is the capital of Italy"
                }
              ]
            }
          ])
puts response.dig("predictions", 0, "candidates", 0, "content")
# => "Rome is the capital and largest city of Italy."
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Warning

If you have an `GCP_ACCESS_TOKEN` and `GCP_PROJECT_ID` in your `ENV`, running the specs will use this to run the specs against the actual API, which will be slow and cost you money! Remove it from your environment with `unset` or similar if you just want to run the specs against the stored VCR responses.

## TODO: Release

First run the specs without VCR so they actually hit the API. Set `GCP_ACCESS_TOKEN` and `GCP_PROJECT_ID` in your environment or pass it in like this:

```
GCP_ACCESS_TOKEN=123abc GCP_PROJECT_ID=456def bundle exec rspec
```

Then update the version number in `version.rb`, update `CHANGELOG.md`, run `bundle install` to update Gemfile.lock, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/niciliketo/ruby-gcp-llm>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/niciliketo/ruby-gcp-llm/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruby Google::Cloud::LLM project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/niciliketo/ruby-gcp-llm/blob/main/CODE_OF_CONDUCT.md).
