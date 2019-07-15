RSpec.describe DetectDiscrepancies::RemoteCampaign do
  before do
    body = '{ "ads": [ { "reference": "1", "status": "enabled", "description": "Description for campaign 11" }, { "reference": "2", "status": "disabled", "description": "Description for campaign 12" }, { "reference": "3", "status": "enabled", "description": "Description for campaign 13" } ] }'

    stub_request(:get, 'http://dummy.com/ref-1').to_return(body: body)
  end

  describe '#fetch_ads' do
    subject {
      described_class.new('http://dummy.com/ref-1')
    }

    it 'returns instance of RemoteCampaign' do
      expect(subject.find_ad('1').reference).to eq('1')
    end
  end
end