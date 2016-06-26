require 'rails_helper'

RSpec.describe "admin/users/index", type: :view do
  let(:user) { create(:user) }
  before(:each) { allow(controller).to receive(:current_user).and_return(user) }
  before(:each) do
    assign(:users, create_list(:user, 2))
  end

  it "renders a list of users" do
    render
  end
end
