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

  private

  def fixture_dirname
    File.expand_path("../../../fixtures", __FILE__)
  end
end
