require 'rails_helper'

RSpec.describe "admin/users/new", type: :view do
  before(:each) do
    assign(:user, build(:admin_user))
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", admin_users_path, "post" do
    end
  end
end
