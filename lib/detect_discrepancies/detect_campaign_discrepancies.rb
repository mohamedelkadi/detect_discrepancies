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
        remote_ad = find_remote_ad(local_ad)
        next not_exist_error(local_ad) if remote_ad.nil?

        discrepancies_hash(local_ad, remote_ad)
      end
    end

    private

    def find_remote_ad(local_ad)
      remote_campaign.find_ad(local_ad.external_reference)
    end

    def discrepancies_hash(local_ad, remote_ad)
      { remote_reference: local_ad.external_reference,
        discrepancies: single_ad_discrepancies(local_ad, remote_ad) }
    end

    def not_exist_error(local_ad)
      { remote_reference: local_ad.external_reference,
        error: 'Not exist' }
    end

    def single_ad_discrepancies(local_ad, remote_ad)
      DetectSingleAdDiscrepancies
        .new(local_ad: local_ad,
             remote_ad: remote_ad)
        .detect_discrepancies
    end

  end
end