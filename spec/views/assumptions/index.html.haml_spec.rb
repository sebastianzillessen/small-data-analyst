require 'rails_helper'

RSpec.describe "assumptions/index", type: :view do
  subject{FactoryGirl.create_list(:assumption, 2)}
  before(:each) do
    assign(:assumptions, subject)
  end

  it "renders a list of assumptions" do
    render
    expect(rendered).to match subject.first.name
    expect(rendered).to match subject.last.name
    # todo further test
  end
end
