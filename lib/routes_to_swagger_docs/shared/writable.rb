module RoutesToSwaggerDocs
  module Writable
     def write_after_deep_merge(save_path, result)
      if FileTest.exists?(save_path)
        yaml = YAML.load_file(save_path)
        result.deep_merge!(yaml)
      end
      File.write(save_path, result.to_yaml)
    end
  end
end
