require 'rails_helper'

RSpec.describe "analyses/new", type: :view do
  before(:each) do
    assign(:analysis, Analysis.new())
  end

  it "renders new analysis form" do
    render

    assert_select "form[action=?][method=?]", analyses_path, "post" do
    end
  end
end
