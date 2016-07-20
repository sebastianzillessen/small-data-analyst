require 'rails_helper'

RSpec.describe "preferences/show", type: :view do
  before(:each) do
    @preference = assign(:preference, create(:preference))
  end

  let(:user) { create(:user) }
  before(:each) { allow(controller).to receive(:current_user).and_return(user) }

  it "renders attributes in <p>" do
    render
  end
end
