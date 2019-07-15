module DetectDiscrepancies

  class DetectCampaignDiscrepancies
    attr_reader :local_campaign, :remote_campaign, :discrepancies

    def initialize(local_campaign:, remote_campaign:)
      @local_campaign = local_campaign
      @remote_campaign = remote_campaign
      @discrepancies = []
    end

    def detect_discrepancies
      local_campaign.map do |local_ad|
        ref = local_ad.external_reference
        remote_ad = remote_campaign.find_ad(ref)

        { remote_reference: ref,
          discrepancies: single_ad_discrepancies(local_ad, remote_ad) }
      end
    end

    private

    def single_ad_discrepancies(local_ad, remote_ad)
      DetectSingleAdDiscrepancies
        .new(local_ad: local_ad,
             remote_ad: remote_ad)
        .detect_discrepancies
    end

  end
end