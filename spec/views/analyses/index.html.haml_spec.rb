require 'rails_helper'

RSpec.describe "analyses/index", type: :view do
  let(:user) { create(:user) }
  before(:each) { allow(controller).to receive(:current_user).and_return(user) }

  before(:each) do
    assign(:analyses, create_list(:analysis, 2))
  end

  it "renders a list of analyses" do
    render
  end
end
