require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    it "works! (now write some real specs)" do
      login_user(create(:admin))
      get admin_users_path
      expect(response).to have_http_status(200)
    end
  end
end