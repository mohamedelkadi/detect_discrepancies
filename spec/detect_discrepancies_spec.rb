RSpec.describe DetectDiscrepancies do
  it "has a version number" do
    expect(DetectDiscrepancies::VERSION).not_to be nil
  end

  it 'responds to call method' do
    expect(described_class).to respond_to(:call)
  end

  it 'responds to configure method' do
    expect(described_class).to respond_to(:configure)
  end

  describe '#configure' do
    let(:blk) do
      lambda { |config|
        config.checked_properties = %i[ x y ]
        config.api_url = 'https:://sample.example'
      }
    end

    it 'accepts block and pass the Configuration class to it ' do
      expect { |blk| described_class.configure(&blk) }.to yield_with_args(DetectDiscrepancies::Configuration)
    end

    it 'sets the api_url value' do
      described_class.configure(&blk)

      expect(DetectDiscrepancies::Configuration.api_url).to eq('https:://sample.example')
    end

    it 'sets the checked_properties value' do
      expect(DetectDiscrepancies::Configuration.checked_properties).to eq( %i[ x y ])
    end
  end
end
