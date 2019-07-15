RSpec.describe DetectDiscrepancies::RemoteCampaign do
  before do
    body = '{ "ads": [ { "reference": "1", "status": "enabled", "description": "Description for campaign 11" }, { "reference": "2", "status": "disabled", "description": "Description for campaign 12" }, { "reference": "3", "status": "enabled", "description": "Description for campaign 13" } ] }'

    stub_request(:get, 'http://dummy.com').to_return(body: body)
  end

  describe '#find_ad' do
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