#frozen_string_literal:true

require 'docker'
require 'eventmachine'
require 'watir'
require 'tempfile'
require 'fileutils'
require 'shell'
require 'forwardable'

require_relative 'analyzer'
require_relative 'generator'
require_relative 'base'


# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class Editor < Base
      extend Forwardable

      TMP_FILE_NAME = "edited_schema"

      attr_accessor :edited_schema

      def initialize(*args)
        super
        @editor = swagger.editor
      end

      def start
        EM.run do
          container.start
          open_browser_and_set_schema
          ensure_save_tmp_schema_file
          signal_trap("INT")
          signal_trap("TERM")
        end
      end

      private

      attr_accessor :container, :unit_paths_file_path
      def_delegators :@editor, :storage_key, :image, :port, :url, :exposed_port

      def signal_trap(command)
        Signal.trap(command) do
          if @browser.exists?
            process_after_close_browser
            container.stop
            container.remove
            logger.info "container id: #{container.id} removed"
          else
            process_after_close_browser
            container.remove
            logger.info "container id: #{container.id} removed"
          end
          
          EM.stop
        end
      end

      def process_after_close_browser
        fetch_edited_schema_from_browser do |path|
          logger.info "\nsave updated schema in tempfile path: #{path}"
          options = { type: :edited, edited_schema_file_path: path }
          analyzer = Analyzer.new({}, options)
          analyzer.update_from_schema
        end
      end

      def ensure_save_tmp_schema_file
        EM.add_periodic_timer(interval_to_save_edited_tmp_schema) do
          if @browser.exists?
            @schema = @browser.driver.local_storage[storage_key] || @schema
            puts "\nwait for single trap ..."
          end
        end
      end

      def fetch_edited_schema_from_browser(&block)
        if @browser.exists?
          @schema = @browser.driver.local_storage[storage_key] 
        end
        
        FileUtils.mkdir_p("tmp") unless FileTest.exists?("tmp")
        Tempfile.create([TMP_FILE_NAME, '.yaml'], 'tmp') do |f|
          f.write @schema
          yield f.path if block_given?
        end
      end

      def open_browser_and_set_schema
        @browser ||= Watir::Browser.new
        @browser.goto(url)
        if wait_for_loaded
          schema_doc_from_local = YAML.load_file(doc_save_file_path)
          @browser.driver.local_storage[storage_key] = schema_doc_from_local.to_yaml
          @browser.refresh
        end
      end

      def wait_for_loaded
        Watir::Wait.until { @browser.body.present? }
      end

      def container
        @container ||= Docker::Container.create(
          'Image' => image,
          'ExposedPorts' => { exposed_port => {} },
          'HostConfig' => {
            'PortBindings' => {
              exposed_port => [{ 'HostPort' => port }]
            }
          }
        )
      end
    end
  end
end