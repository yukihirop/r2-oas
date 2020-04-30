# frozen_string_literal: true

module TaskHelper
  def generate_docs(options = {})
    generator = R2OAS::Schema::Generator.new(options)
    generator.generate_docs
  end

  def build_docs(options = {})
    builder = R2OAS::Schema::Builder.new(options)
    builder.build_docs
  end
end
