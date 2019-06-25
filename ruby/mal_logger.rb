require "logger"

MAL_LOGGER ||= Logger.new("./info.log").tap do |logger|
  logger.formatter = proc { |severity, datetime, progname, msg|
    "[#{severity}]: #{msg}\n"
  }
end
