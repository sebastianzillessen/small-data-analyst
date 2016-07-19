require 'rails_helper'

describe 'phantomJs' do
  it 'should be of version 2.0.0 or higher' do
    version = `phantomjs --version`
    expect(Gem::Version.new(version)).to be >= Gem::Version.new('2.0.0')
  end
end