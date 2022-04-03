# frozen_string_literal: true

require_relative "lib/tornados/version"

Gem::Specification.new do |spec|
  spec.name = "tornados"
  spec.version = Tornados::VERSION
  spec.authors = ["Alexey Slivka"]
  spec.email = ["slivka77@inbox.ru"]

  spec.summary = "Gem and cli for get tor exit nodes IP list with geoip enrichment."
  spec.description = "Gem and cli for get tor exit nodes IP list with geoip enrichment."
  spec.homepage = "https://github.com/atilla777/tornados"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/atilla777/tornados"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "faraday", "~> 2.2.0"
  spec.add_dependency "maxmind-geoip2", "~> 1.1.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
  spec.add_development_dependency "pry"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
