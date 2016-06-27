require 'rails_helper'

RSpec.describe "datasets/show", type: :view do
  before(:each) do
    @dataset = assign(:dataset, create(:dataset))
  end

  it "renders attributes in <p>" do
    render
  end
end
