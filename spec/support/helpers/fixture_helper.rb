# frozen_string_literal: true

module FixtureHelper
  def swagger_file_path(type)
    case type
    when :json
      "#{fixture_dirname}/swagger.json"
    when :yaml
      "#{fixture_dirname}/swagger.yaml"
    when :yml
      "#{fixture_dirname}/swagger.yml"
    end
  end

  def editor_file_path(type)
    case type
    when :before
      "#{fixture_dirname}/editor/before.yml"
    when :after
      "#{fixture_dirname}/editor/after.yml"
    end
  end

  def docs_file_path(type)
    case type
    when :before
      "#{fixture_dirname}/docs/before.yml"
    end
  end

  def yaml_fixture(relative_path)
    YAML.load_file("#{fixture_dirname}/#{relative_path}").to_yaml
  end

  private

  def fixture_dirname
    File.expand_path('../../fixtures', __dir__)
  end
end
