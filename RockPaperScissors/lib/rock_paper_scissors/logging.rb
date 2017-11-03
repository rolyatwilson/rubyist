# frozen_string_literal: true

module Logging
  def logger
    Logging.logger
  end

  def self.logger
    return @logger if @logger
    @logger = Logger.new(STDOUT)
    logger.formatter = proc do |severity, _time, _progname, message|
      prefix = severity == 'INFO' ? '' : "#{severity}: "

      "[#{_time}]  #{prefix}#{message}".strip + "\n"
    end
    @logger
  end
end
