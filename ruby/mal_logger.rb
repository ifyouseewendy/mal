require "logger"

MAL_LOGGER ||= Logger.new(File.expand_path("./../info.log", __FILE__)).tap do |logger|
  logger.formatter = proc { |severity, datetime, progname, msg|
    "[#{severity}]: #{msg}\n"
  }
end
