# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'r2-oas/version'

Gem::Specification.new do |spec|
  spec.name          = 'r2-oas'
  spec.version       = R2OAS::VERSION
  spec.authors       = ['yukihirop']
  spec.email         = ['te108186@gmail.com']

  spec.summary       = 'Generate api docment(OpenAPI) side only from rails routing.'
  spec.description   = <<~EOF
    Generate api docment(OpenAPI) side only from `rails` routing.
    Provides rake commands to help `docs`, `edit`, `view` and so on.

    ```
    bundle exec rake routes:oas:docs    # generate
    bundle exec rake routes:oas:ui      # view
    bundle exec rake routes:oas:editor  # edit
    bundle exec rake routes:oas:monitor # monitor
    bundle exec rake routes:oas:dist    # distribute
    bundle exec rake routes:oas:clean   # clean
    bundle exec rake routes:oas:analyze # analyze
    bundle exec rake routes:oas:deploy  # deploy
    ```
  EOF

  spec.homepage      = 'https://github.com/yukihirop/r2-oas'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.3p222')

  spec.add_runtime_dependency 'docker-api', '~> 1.34.2'
  spec.add_runtime_dependency 'easy_diff', '~> 1.0.0'
  spec.add_runtime_dependency 'eventmachine', '~> 1.2.0'
  spec.add_runtime_dependency 'paint'
  spec.add_runtime_dependency 'rails', '>= 4.2.5'
  spec.add_runtime_dependency 'terminal-table', '~> 1.6.0'
  spec.add_runtime_dependency 'watir', '~> 6.0'
  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
