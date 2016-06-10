require 'rails_helper'

RSpec.describe "analyses/index", type: :view do
  before(:each) do
    assign(:analyses, create_list(:analysis, 2))
  end

  it "renders a list of analyses" do
    render
  end
end
