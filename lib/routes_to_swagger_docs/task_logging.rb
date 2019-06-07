# Scope Rails
module RoutesToSwaggerDocs
  module TaskLogging
    def task(*args, &block)
      Rake::Task.define_task(*args) do |task|
        if block_given?
          debug_log task, "[#{task.name}] started"
          begin
            block.call(task)
            debug_log task, "[#{task.name}] finished"
          rescue => exception
            debug_log task, "[#{task.name}] failed"
            raise exception
          end
        end
      end
    end

    private

    def logger
      RoutesToSwaggerDocs.logger
    end

    def set_info_level
      RoutesToSwaggerDocs.logger.level = StdoutLogger::INFO
    end

    def set_debug_level
      RoutesToSwaggerDocs.logger.level = StdoutLogger::DEBUG
    end

    def debug_log(task, message)
      unless task.name == "routes:swagger:debug"
        RoutesToSwaggerDocs.logger.debug "#{message}"
      end
    end
  end
end