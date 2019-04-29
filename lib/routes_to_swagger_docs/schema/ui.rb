#frozen_string_literal:true

require 'docker'
require 'eventmachine'
require 'watir'
require 'shell'

require_relative 'analyzer'
require_relative 'base'


# Scope Rails
module RoutesToSwaggerDocs
  module Schema
    class UI < Base
      SWAGGER_UI_IMAGE = "swaggerapi/swagger-ui"
      SWAGGER_UI_PORT  = "8080"
      SWAGGER_UI_URL   = "http://localhost:#{SWAGGER_UI_PORT}"

      alias :swagger_json :doc_save_file_path

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

      def signal_trap(command)
        Signal.trap(command) do
          container.stop
          container.remove
          puts "container id: #{container.id} removed"
          
          EM.stop
        end
      end

      def open_browser
        @browser ||= Watir::Browser.new
        @browser.goto(SWAGGER_UI_URL)
        wait_for_loaded
      end

      def wait_for_loaded
        Watir::Wait.until { @browser.body.present? }
      end

      # [Reference]
      # https://www.tomduffield.com/files/presentations/the-nitty-gritty-of-the-docker-api.pdf
      def container
        @container ||= Docker::Container.create(
          'Image' => SWAGGER_UI_IMAGE,
          'ExposedPorts' => { '8080/tcp' => {} },
          'HostConfig' => {
            'PortBindings' => {
              '8080/tcp' => [{ 'HostPort' => SWAGGER_UI_PORT }]
            },
            'Binds' => [ "#{swagger_json}:/app/swagger.json" ] 
          },
          'Volumes' => { "/app/swagger.json" =>  { } }
        )
      end
    end
  end
end
