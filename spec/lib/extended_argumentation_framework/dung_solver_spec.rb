require 'rails_helper'

RSpec.describe ExtendedArgumentationFramework::DungSolver, type: :class do

  let(:framework) { ExtendedArgumentationFramework::Framework.new("a1->a2,a3->a2,a3->a4,a4->a3,a5->a5,a4->a5") }
  subject { ExtendedArgumentationFramework::DungSolver.new(framework) }
  let(:a1) { ExtendedArgumentationFramework::Argument.new("a1") }
  let(:a2) { ExtendedArgumentationFramework::Argument.new("a2") }
  let(:a3) { ExtendedArgumentationFramework::Argument.new("a3") }
  let(:a4) { ExtendedArgumentationFramework::Argument.new("a4") }
  let(:a5) { ExtendedArgumentationFramework::Argument.new("a5") }

  it 'should return two preferred extension' do
    expect(subject.preferred_extensions.length).to eq 2
  end
  it 'should contain the preferred extension a1,a3' do
    expect(subject.preferred_extensions.map { |pe| pe.arg_in }).to include([a1, a3])
  end
  it 'should contain the preferred extension a1,a4' do
    expect(subject.preferred_extensions.map { |pe| pe.arg_in }).to include([a1, a4])
  end
end