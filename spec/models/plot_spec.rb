require 'rails_helper'

RSpec.describe Plot, type: :model do
  subject { build(:plot) }

  it { is_expected.not_to be_valid }

  it 'should validate filename' do
    expect(File).to receive(:exist?).once.with("#{Plot::BASE_URL}/#{subject.filename}").and_return(true)
    is_expected.to be_valid
  end
end
