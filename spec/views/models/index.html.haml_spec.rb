require 'rails_helper'

RSpec.describe "models/index", type: :view do
  subject{FactoryGirl.create_list(:model, 2)}
  before(:each) do
    assign(:models, subject)
  end

  it "renders a list of model names" do
    render
    assert_select "tr>td", :text => subject.first.name
    assert_select "tr>td", :text => subject.last.name
  end
end
