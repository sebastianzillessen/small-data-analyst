require 'rails_helper'

RSpec.describe "ResearchQuestions", type: :request do
  describe "GET /research_questions" do
    it "works! (now write some real specs)" do
      get research_questions_path
      expect(response).to have_http_status(200)
    end
  end
end
