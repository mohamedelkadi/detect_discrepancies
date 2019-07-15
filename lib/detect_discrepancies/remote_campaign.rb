module DetectDiscrepancies
  class RemoteCampaign
    Ad = Struct.new(:reference, :status, :description)

    attr_reader :api_url, :ads

    def initialize(api_url)
      @api_url = api_url
      @ads = {}
      fetch_ads
    end

    def find_ad(ref)
      ads[ref]
    end

    private

    def fetch_ads
      res_body = fetch_data

      initialize_from_response(res_body)
    end

    def initialize_from_response(res_body)
      res_body['ads'].each do |ad|
        @ads[ad['reference']] = Ad.new(ad['reference'],
                                       ad['status'],
                                       ad['description'])
      end
    end

    def fetch_data
      uri = URI(api_url)
      res = Net::HTTP.get_response(uri)

      raise ServiceNotAvailable unless res.is_a?(Net::HTTPSuccess)

      JSON.parse(res.body)
    end
  end
end