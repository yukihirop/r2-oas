module TaskHelper
  def generate_docs(options = {})
    generator = RoutesToSwaggerDocs::Schema::Generator.new(options)
    generator.generate_docs
  end
end
