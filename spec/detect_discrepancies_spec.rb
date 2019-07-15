RSpec.describe DetectDiscrepancies do
  it 'has a version number' do
    expect(DetectDiscrepancies::VERSION).not_to be nil
  end

  it 'responds to call method' do
    expect(described_class).to respond_to(:call)
  end

  describe '.call' do
    context 'when the input is correct and ad service available' do
      let(:local_campaign) do
        [double('Local Campaign', id: 1, job_id: 1,
                                  external_reference: '1',
                                  status: 'active',
                                  ad_description: 'Ruby on Rails Developer')]
      end

      let(:remote_api_url) { 'http://www.dummyremote.com' }
      body = { ads: [{ 'reference': '1', 'status': 'disabled',
                       'description': 'Rails Engineer' }] }.to_json
      before do
        stub_request(:get, remote_api_url).to_return(body: body)
      end

      let(:expected_result) do
        [
          {
            'remote_reference': '1',
            'discrepancies': [
              { 'status': {
                'remote': 'disabled',
                'local': 'active'
              } },
              { 'description': {
                'remote': 'Rails Engineer',
                'local': 'Ruby on Rails Developer'
              } }
            ]
          }
        ]
      end

      let(:ret) do
        described_class.call(local_campaign: local_campaign,
                             remote_api_url: remote_api_url)
      end

      it 'returns the correct reference' do
        returned_ref = ret.first['remote_reference']
        expected_ref = expected_result.first['remote_reference']

        expect(returned_ref).to eq(expected_ref)
      end

      it 'returns the expected status discrepancies' do
        returned_status = ret.first[:discrepancies].first.to_json
        expected_status = expected_result.first[:discrepancies].first.to_json

        expect(returned_status).to match(expected_status)
      end

      it 'returns the expected description discrepancies' do
        returned_description = ret.first[:discrepancies].last.to_json
        expected_description = expected_result.first[:discrepancies].last.to_json

        expect(returned_description).to match(expected_description)
      end
    end
  end
end
