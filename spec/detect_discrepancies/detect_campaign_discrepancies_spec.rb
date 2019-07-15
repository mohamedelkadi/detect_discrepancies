module DetectDiscrepancies
  RSpec.describe DetectCampaignDiscrepancies do
    describe '#detect_discrepancies' do
      let(:ref) { 1 }

      let(:local_campaign) { [local_ad] }
      let(:detector) {
        described_class.new(
          local_campaign: local_campaign,
          remote_campaign: remote_campaign
        )
      }
      subject do
        detector.detect_discrepancies
      end

      let(:remote_campaign) { instance_double(RemoteCampaign) }

      before do
        allow(detector).to receive(:single_ad_discrepancies)
      end

      context 'local campaign has no ads' do
        let(:local_campaign) { [] }

        it 'returns empty array' do
          expect(subject).to eq([])
        end
      end

      context 'local has one ad that exists in remote campaign' do

        let(:local_ad) { double('Local Ad', external_reference: ref) }
        let(:local_campaign) { [local_ad] }

        before do
          allow(remote_campaign).to receive(:find_ad)
        end

        it 'returns array of size 1' do
          expect(subject.size).to eq(1)
        end

        it 'returns the discrepancies for this ref' do
          expect(subject.first[:remote_reference]).to eq(ref)
        end
      end

      context 'local has one ad that does not exist in remote campaign' do
        let(:local_ad) { double('Local Ad', external_reference: '200') }
        let(:local_campaign) { [local_ad] }

        before do
          allow(remote_campaign).to receive(:find_ad).and_return(nil)
        end

        it 'returns the errors for this ref' do
          expect(subject.first[:remote_reference]).to eq('200')
          expect(subject.first[:error]).to eq('Not exist')
        end
      end
    end
  end
end
