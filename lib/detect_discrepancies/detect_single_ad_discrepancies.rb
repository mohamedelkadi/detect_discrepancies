module DetectDiscrepancies
  class DetectSingleAdDiscrepancies
    attr_reader :remote_ad, :local_ad, :discrepancies

    def initialize(remote_ad:, local_ad:)
      @remote_ad = remote_ad
      @local_ad = local_ad
      @discrepancies = []
    end

    def detect_discrepancies
      detect_status_discrepancies
      detect_description_discrepancies

      discrepancies
    end

    private

    def detect_status_discrepancies
      return if local_ad.status == remote_ad.status

      discrepancies.push({status: { remote: remote_ad.status,
                                   local: local_ad.status }})
    end

    def detect_description_discrepancies
      return if local_ad.ad_description == remote_ad.description

      discrepancies.push({ description: { remote: remote_ad.description,
                                          local: local_ad.ad_description
      } })
    end
  end
end