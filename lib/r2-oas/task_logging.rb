# frozen_string_literal: true

# Scope Rails
module R2OAS
  module TaskLogging
    def task(*args, &block)
      Rake::Task.define_task(*args) do |task|
        if block_given?
          debug_log task, "[#{task.name}] started"
          begin
            block.call(task)
            debug_log task, "[#{task.name}] finished"
          rescue StandardError => e
            debug_log task, "[#{task.name}] failed"
            raise e
          end
        end
      end
    end

    private

    def start
      logger.info '[R2-OAS] start'
      yield
      logger.info '[R2-OAS] end'
    end

    def logger
      R2OAS.logger
    end

    def set_info_level
      R2OAS.logger.level = StdoutLogger::INFO
    end

    def set_debug_level
      R2OAS.logger.level = StdoutLogger::DEBUG
    end

    def debug_log(task, message)
      R2OAS.logger.debug message.to_s unless task.name == 'routes:oas:debug'
    end
  end
end
