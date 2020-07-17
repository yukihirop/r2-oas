# frozen_string_literal: true

module R2OAS
  class NoImplementError < StandardError; end
  class NoFileExistsError < StandardError; end
  class NoSupportError < StandardError; end
  class ChecksumError < StandardError; end
  class PluginNameError < StandardError; end
  class PluginDuplicationError < StandardError; end
  class PluginLoadError < StandardError; end
  class DepulicateSchemaNameError < StandardError; end
end
