require 'rails_helper'

RSpec.describe "preferences/edit", type: :view do
  before(:each) do
    @preference = assign(:preference, create(:preference))
  end

  let(:user) { create(:user) }
  before(:each) { allow(controller).to receive(:current_user).and_return(user) }

  it "renders the edit preference form" do
    render

    assert_select "form[action=?][method=?]", preference_path(@preference), "post" do
    end
  end
end
