require 'rails_helper'

RSpec.describe "Assumptions", type: :request do
  describe "GET /assumptions" do
    it "works! (now write some real specs)" do
      get assumptions_path
      expect(response).to have_http_status(200)
    end
  end
end
