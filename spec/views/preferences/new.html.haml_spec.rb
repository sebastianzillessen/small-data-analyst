require 'rails_helper'

RSpec.describe "preferences/new", type: :view do
  before(:each) do
    assign(:preference, create(:preference))
  end

  let(:user) { create(:user) }
  before(:each) { allow(controller).to receive(:current_user).and_return(user) }

  it "renders new preference form" do
    render

    assert_select "form[action=?][method=?]", preferences_path, "post" do
    end
  end
end
