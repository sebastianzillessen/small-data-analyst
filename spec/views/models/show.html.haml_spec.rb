require 'rails_helper'

RSpec.describe "models/show", type: :view do
  subject{FactoryGirl.create(:model)}
  before(:each) do
    @model = assign(:model, subject)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to include subject.name
    expect(rendered).to include subject.description
  end
end
