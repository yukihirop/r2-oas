#frozen_string_literal:true

require 'docker'
require 'eventmachine'
require 'watir'
require 'tempfile'
require 'fileutils'
require 'shell'

require_relative 'analyzer'
require_relative 'generator'
require_relative 'base'


# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class Editor < Base
      SWAGGER_EDITOR_STORAGE_KEY = "swagger-editor-content"
      SWAGGER_EDITOR_IMAGE       = "swaggerapi/swagger-editor"
      SWAGGER_EDITOR_PORT        = "81"
      SWAGGER_EDITOR_URL         = "http://localhost:81"
      TMP_FILE_NAME              = "edited_schema"

      attr_accessor :edited_schema

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

      attr_accessor :container, :unit_paths_file_path

      def signal_trap(command)
        Signal.trap(command) do
          if @browser.exists?
            fetch_edited_schema_from_browser
            puts "\nsave updated schema in tempfile path: #{@tempfile_path}"
            analyzer = Analyzer.new({}, edited_schema_file_path: @tempfile_path)
            analyzer.update_from_edited_schema
          end

          container.stop
          container.remove
          puts "container id: #{container.id} removed"
          
          EM.stop
        end
      end

      def fetch_edited_schema_from_browser
        @tempfile_path = nil
        @schema = @browser.driver.local_storage[SWAGGER_EDITOR_STORAGE_KEY]
        FileUtils.mkdir_p("tmp") unless FileTest.exists?("tmp")
        file = Tempfile.open([TMP_FILE_NAME, '.yaml'], 'tmp') do |f|
          f.write @schema
          f
        end

        @tempfile_path = file.path
        self
      end

      def open_browser_and_set_schema
        @browser ||= Watir::Browser.new
        @browser.goto(SWAGGER_EDITOR_URL)
        if wait_for_loaded
          schema_doc_from_local = YAML.load_file(doc_save_file_path)
          @browser.driver.local_storage[SWAGGER_EDITOR_STORAGE_KEY] = schema_doc_from_local.to_yaml
          @browser.refresh
        end
      end

      def wait_for_loaded
        Watir::Wait.until { @browser.body.present? }
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
    end
  end
end