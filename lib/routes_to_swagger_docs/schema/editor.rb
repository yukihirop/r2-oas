require 'docker'
require 'eventmachine'
require 'watir'
require 'tempfile'
require 'fileutils'
require 'shell'

require_relative 'analyzer'
require_relative '../generator'

# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class Editor
      SWAGGER_EDITOR_STORAGE_KEY = "swagger-editor-content"
      SWAGGER_EDITOR_IMAGE       = "swaggerapi/swagger-editor"
      SWAGGER_EDITOR_PORT        = "81"
      SWAGGER_EDITOR_URL         = "http://localhost:81"
      TMP_FILE_NAME              = "edited_schema"

      
      attr_accessor :edited_schema
      
      def initialize(options = {})
        self.merged_options = RoutesToSwaggerDocs.options.merge(options)
      
        Configuration::VALID_OPTIONS_KEYS.each do |key|
          send("#{key}=", merged_options[key])
        end
      end

      def start
        EM.run do
          container.start
          open_browser_and_set_schema
          puts "\nwait for single trap ..."
          signal_trap("INT")
          signal_trap("TERM")
        end
      end

      private

      attr_accessor :container
      attr_accessor *Configuration::VALID_OPTIONS_KEYS, :merged_options

      def signal_trap(command)
        Signal.trap(command) do
          if @browser.exists?
            fetch_edited_schema_from_browser
            puts "\nsave updated schema in tempfile path: #{@tempfile_path}"
            analyzer = Analyzer.new(@tempfile_path)
            analyzer.update_schema
          end

          container.stop
          container.remove
          puts "container id: #{container.id} removed"
          
          EM.stop
        end
      end

      def fetch_edited_schema_from_browser
        @tempfile_path = nil
        @edited_schema = @browser.driver.local_storage[SWAGGER_EDITOR_STORAGE_KEY]
        FileUtils.mkdir_p("tmp") unless FileTest.exists?("tmp")
        file = Tempfile.open([TMP_FILE_NAME, '.yaml'], 'tmp') do |f|
          f.write @edited_schema
          f
        end

        @tempfile_path = file.path
        self
      end

      def open_browser_and_set_schema
        @browser ||= Watir::Browser.new
        @browser.goto(SWAGGER_EDITOR_URL)
        if wait_for_loaded
          @browser.driver.local_storage[SWAGGER_EDITOR_STORAGE_KEY] = schema_doc_from_local.to_yaml
          @browser.refresh
        end
      end

      def wait_for_loaded
        Watir::Wait.until { @browser.body.present? }
      end

      def schema_doc_from_local
        shell = Shell.new
        shell.pushd(root_dir_path) do
          generator = RoutesToSwaggerDocs::Generator.new
          generator.generate_docs
        end
        YAML.load_file(doc_save_file_path)
      end

      def container
        @container ||= Docker::Container.create(
          'Image' => SWAGGER_EDITOR_IMAGE,
          'ExposedPorts' => { '8080/tcp' => {} },
          'HostConfig' => {
            'PortBindings' => {
              '8080/tcp' => [{ 'HostPort' => SWAGGER_EDITOR_PORT }]
            }
          }
        )
      end

      def doc_save_file_path
        "#{root_dir_path}/#{doc_save_file_name}"
      end
    end
  end
end