require 'rails_helper'

RSpec.describe "analyses/edit", type: :view do
  before(:each) do
    @analysis = assign(:analysis, create(:analysis))
  end

  it "renders the edit analysis form" do
    render

    assert_select "form[action=?][method=?]", analysis_path(@analysis), "post" do
    end
  end
end
