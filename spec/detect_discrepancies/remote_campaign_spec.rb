module DetectDiscrepancies
  RSpec.describe RemoteCampaign do
    context 'service is available is not available' do
      let(:remote_api_url) { "http://www.downservice.com" }

      before do
        stub_request(:any, remote_api_url).
          to_return(status: [500, "Internal Server Error"])
      end

      it 'raises error' do
        expect { described_class.new(remote_api_url) }.to raise_error(ServiceNotAvailable)
      end
    end

    describe '#find_ad' do
      context 'service is available' do
        before do
          body = '{ "ads": [ { "reference": "1", "status": "enabled", "description": "Description for campaign 11" }, { "reference": "2", "status": "disabled", "description": "Description for campaign 12" }, { "reference": "3", "status": "enabled", "description": "Description for campaign 13" } ] }'

          stub_request(:get, 'http://dummy.com').to_return(body: body)
        end

        subject {
          described_class.new('http://dummy.com')
        }

        it 'finds the ad with the correct reference' do
          expect(subject.find_ad('1').reference).to eq('1')
        end

        it 'finds the ad with the expected status' do
          expect(subject.find_ad('1').status).to eq('enabled')
        end
      end
    end
  end
end