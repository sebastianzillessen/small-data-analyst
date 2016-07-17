require 'rails_helper'

RSpec.describe "preferences/show", type: :view do
  before(:each) do
    @preference = assign(:preference, Preference.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
