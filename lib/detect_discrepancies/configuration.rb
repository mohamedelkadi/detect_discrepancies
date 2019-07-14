require 'active_support/core_ext/module/attribute_accessors'

module DetectDiscrepancies
  class Configuration
    cattr_accessor :checked_properties, :api_url
  end
end