module DetectDiscrepancies
  RSpec.describe DetectSingleAdDiscrepancies do
    describe '#detect_discrepancies' do
      subject do
        described_class.new(
          local_ad: local_ad,
          remote_ad: remote_ad
        ).detect_discrepancies
      end

      context 'when ads are in sync ' do
        let(:local_ad) do
          double('Local',
                 status: 'active',
                 ad_description: 'Ruby on Rails Developer')
        end

        let(:remote_ad) do
          double('Remote',
                 status: 'active',
                 description: 'Ruby on Rails Developer')
        end

        it 'returns empty arry' do
          expect(subject).to eq([])
        end
      end

      context 'when ads are not in sync' do
        let(:local_ad) do
          double('Local',
                 status: 'active',
                 ad_description: 'Ruby on Rails Developer')
        end

        let(:remote_ad) do
          double('Remote',
                 status: 'disabled',
                 description: 'Rails Engineer')
        end
        it 'returns the discrepancies' do
          expect(subject.first).to include(status: { remote: 'disabled',
                                                     local: 'active' })
        end
        it 'returns the discrepancies' do
          expect(subject.last).to include(description: { remote: 'Rails Engineer',
                                                         local: 'Ruby on Rails Developer' })
        end
      end
    end
  end
end