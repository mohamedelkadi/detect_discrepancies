require "detect_discrepancies/version"
require 'detect_discrepancies/configuration'

module DetectDiscrepancies

  def self.call(campaign:)
  end

  def self.configure(&config)
    config.call(Configuration)
  end

  class Error < StandardError
  end
end
