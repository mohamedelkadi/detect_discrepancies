module DetectDiscrepancies

  class Detector
    attr_reader :local_campaign, :remote_campaign

    def initialize(local_campaign:, remote_campaign:)
      @local_campaign = local_campaign
      @remote_campaign = remote_campaign
    end

    def discrepancies
      properties.map do |prop|
        local_value = local_campaign.send(prop)
        remote_value = remote_campaign.send(prop)
        next if local_value == remote_value

        discrepancies = {}
        discrepancies[prop] = { remote: remote_value,
                                local: local_value }
        discrepancies
      end
    end

    private

    def properties
      Configuration.checked_properties
    end
  end
end