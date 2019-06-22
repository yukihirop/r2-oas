
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "routes_to_swagger_docs/version"

Gem::Specification.new do |spec|
  spec.name          = "routes_to_swagger_docs"
  spec.version       = RoutesToSwaggerDocs::VERSION
  spec.authors       = ["yukihirop"]
  spec.email         = ["te108186@gmail.com"]

  spec.summary       = "Generate swagger docs (side only) from rails routing."
  spec.description   = "Generate swagger docs (side only) from rails routing."
  spec.homepage      = "https://github.com/yukihirop/routes_to_swagger_docs"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails", "~> 4.2.5"
  spec.add_runtime_dependency "docker-api", "~> 1.34.2"
  spec.add_runtime_dependency "eventmachine", "~> 1.2.0"
  spec.add_runtime_dependency "watir", "~> 6.0"
  spec.add_runtime_dependency "easy_diff", "~> 1.0.0"
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
