require 'rails_helper'

RSpec.describe "preferences/index", type: :view do
  before(:each) do
    assign(:preferences, create_list(:preference, 2))
  end

  it "renders a list of preferences" do
    render
    #TODO: wrtie specs
  end
end
