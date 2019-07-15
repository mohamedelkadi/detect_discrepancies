RSpec.describe DetectDiscrepancies do
  it "has a version number" do
    expect(DetectDiscrepancies::VERSION).not_to be nil
  end

  it 'responds to call method' do
    expect(described_class).to respond_to(:call)
  end
end
