RSpec.describe DetectDiscrepancies do
  it 'has a version number' do
    expect(DetectDiscrepancies::VERSION).not_to be nil
  end

  it 'responds to call method' do
    expect(described_class).to respond_to(:call)
  end

  describe '.call' do
    let(:local_campaign) do
      [
        double('Local Campaign', id: 1, job_id: 1,
               external_reference: '1',
               status: 'active',
               ad_description: 'Ruby on Rails Developer'),
        double('Local Campaign', id: 2, job_id: 1,
               external_reference: '2',
               status: 'active',
               ad_description: 'Node.js Developer'),
      ]
    end

    let(:returned) do
      described_class.call(local_campaign: local_campaign,
                           remote_api_url: remote_api_url)
    end

    context 'when the input is correct and ad service available' do
      let(:remote_api_url) { 'http://www.dummyremote.com' }
      let(:body) do
        { ads: [{ 'reference': '1', 'status': 'disabled',
                  'description': 'Rails Engineer' }] }.to_json
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
          },
          {
            'remote_reference': '2',
            'error': 'Not exist'
          }
        ]
      end


      before do
        stub_request(:get, remote_api_url).to_return(body: body)
      end

      it 'returns the correct reference for first add' do
        returned_ref = returned.first['remote_reference']
        expected_ref = expected_result.first['remote_reference']

        expect(returned_ref).to eq(expected_ref)
      end

      it 'returns the expected status discrepancies' do
        returned_status = returned.first[:discrepancies].first.to_json
        expected_status = expected_result.first[:discrepancies].first.to_json

        expect(returned_status).to match(expected_status)
      end

      it 'returns the expected description discrepancies' do
        returned_description = returned.first[:discrepancies].last.to_json
        expected_description = expected_result.first[:discrepancies].last.to_json

        expect(returned_description).to match(expected_description)
      end

      it 'returns error for reference 2 which does not exists' do
        returned_ref = returned.last['remote_reference']
        expected_ref = expected_result.last['remote_reference']

        expect(returned_ref).to eq(expected_ref)
      end

      it 'returns error for reference 2 which does not exists' do
        returned_error = returned.last['error']
        expected_error = expected_result.last['error']

        expect(returned_error).to eq(expected_error)
      end
    end
    context 'when service is unavailable' do
      let(:remote_api_url) { "http://www.downservice.com" }

      before do
        stub_request(:any, remote_api_url).
          to_return(status: [500, "Internal Server Error"])
      end

      it 'raises error' do
        expect { returned }.to raise_error DetectDiscrepancies::ServiceNotAvailable
      end
    end
  end
end
