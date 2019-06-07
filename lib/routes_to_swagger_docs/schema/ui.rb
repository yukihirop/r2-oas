#frozen_string_literal:true

require 'docker'
require 'eventmachine'
require 'watir'
require 'shell'
require 'forwardable'

require_relative 'analyzer'
require_relative 'base'


# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class UI < Base
      extend Forwardable

      alias :swagger_json :doc_save_file_path

      def initialize(*args)
        super
        @ui = swagger.ui
      end

      def start
        EM.run do
          container.start
          open_browser
          puts "\nwait for single trap ..."
          signal_trap("INT")
          signal_trap("TERM")
        end
      end

      private

      attr_accessor :unit_paths_file_path
      def_delegators :@ui, :image, :port, :url, :exposed_port, :volume

      def signal_trap(command)
        Signal.trap(command) do
          container.stop
          container.remove
          logger.info "container id: #{container.id} removed"
          
          EM.stop
        end
      end

      def open_browser
        @browser ||= Watir::Browser.new
        @browser.goto(url)
        wait_for_loaded
      end

      def wait_for_loaded
        Watir::Wait.until { @browser.body.present? }
      end

      # [Reference]
      # https://www.tomduffield.com/files/presentations/the-nitty-gritty-of-the-docker-api.pdf
      def container
        @container ||= Docker::Container.create(
          'Image' => image,
          'ExposedPorts' => { exposed_port => {} },
          'HostConfig' => {
            'PortBindings' => {
              exposed_port => [{ 'HostPort' => port }]
            },
            'Binds' => [ "#{swagger_json}:#{volume}" ] 
          },
          'Volumes' => { volume =>  { } }
        )
      end
    end
  end
end
