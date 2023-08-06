require_relative "lib/gcp_llm/version"

Gem::Specification.new do |spec|
  spec.name          = "gcp_llm"
  spec.version       = GcpLlm::VERSION
  spec.authors       = ["Nic"]
  spec.email         = ["nmartin@users.noreply.github.com"]

  spec.summary       = "GCP LLM API + Ruby! 🤖❤️"
  spec.homepage      = "https://github.com/alexrudall/ruby-gcp-llm"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/alexrudall/ruby-gcp-llm"
  spec.metadata["changelog_uri"] = "https://github.com/alexrudall/ruby-gcp-llm/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 1"
  spec.add_dependency "faraday-multipart", ">= 1"
end
