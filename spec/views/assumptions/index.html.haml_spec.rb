require 'rails_helper'

RSpec.describe "assumptions/index", type: :view do
  subject{FactoryGirl.create_list(:assumption, 2)}
  before(:each) do
    assign(:assumptions, subject)
  end

  it "renders a list of assumptions" do
    render
    assert_select "tr>td", :text => subject.first.name
    assert_select "tr>td", :text => subject.last.name
    # todo further test
  end
end
