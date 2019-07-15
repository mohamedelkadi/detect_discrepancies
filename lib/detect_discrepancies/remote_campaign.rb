module DetectDiscrepancies
  class RemoteCampaign
    class << self
      def find_by_external_ref(external_ref)
        res_body = fetch_data(external_ref)

        initialize_from_response(res_body)
      end

      private

      def initialize_from_response(res_body)
        remote_campaign = new

        properties.each do |prop|
          remote_campaign.instance_exec do
            define_singleton_method(prop) { res_body[prop.to_s] }
          end
        end

        remote_campaign
      end

      def fetch_data(external_ref)
        uri = URI("#{api_url}/#{external_ref}")
        res = Net::HTTP.get_response(uri)

        JSON.parse(res.body)
      end

      def api_url
        Configuration.api_url
      end

      def properties
        Configuration.checked_properties
      end
    end
  end
end