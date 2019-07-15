RSpec.describe DetectDiscrepancies::RemoteCampaign do
  before do
    DetectDiscrepancies::Configuration.api_url = 'http://dummy.com'
    DetectDiscrepancies::Configuration.checked_properties = %i[status ad_description]

    stub_request(:get, 'http://dummy.com/ref-1').to_return(body: {remote_reference: 'ref-1',
                                                      status: 'active',
                                                      ad_description: 'Good One'}.to_json)
  end

  describe '.find_by_external_ref' do
    subject {
      described_class.find_by_external_ref('ref-1')
    }

    it 'returns instance of RemoteCampaign' do
      expect(subject).to be_a(described_class)
    end

    it 'returns instance of RemoteCampaign' do
      expect(subject.status).to eq('active')
    end
  end
end