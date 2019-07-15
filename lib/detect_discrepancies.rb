require "detect_discrepancies/version"

module DetectDiscrepancies

  def self.call(local_campaign:, remote_api_url:)
    remote_campaign = RemoteCampaign.new(remote_api_url)
    DetectCampaignDiscrepancies.new(local_campaign: local_campaign,
                                    remote_campaign: remote_campaign)
                               .detect_discrepancies
  end


  class ServiceNotAvailable < StandardError
  end
end
