require 'rails_helper'


RSpec.describe "assumptions/show", type: :view do
  subject { FactoryGirl.create(:blank_assumption) }
  # todo test other types
  before(:each) do
    @assumption = assign(:assumption, subject)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(subject.name)
  end
end
