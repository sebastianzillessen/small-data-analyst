require 'rails_helper'

RSpec.describe "Preferences", type: :request do
  describe "GET /preferences" do
    it "works! (now write some real specs)" do
      login_user(create(:statistician))
      get preferences_path
      expect(response).to have_http_status(200)
    end
  end
end
