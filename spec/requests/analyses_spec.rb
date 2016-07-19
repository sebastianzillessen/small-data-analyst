require 'rails_helper'

RSpec.describe "Analyses", type: :request do
  let(:admin) { create(:admin) }
  before(:each) { login_user(admin) }

  describe "GET /analyses" do
    it "works! (now write some real specs)" do
      get analyses_path
      expect(response).to be_success
    end
  end

  let!(:dataset) { create(:dataset_survival) }
  let!(:research_question_survival) { create(:research_question) }
  describe "#new /analyses" do
    before(:each) { get new_analysis_path }
    it 'should be success' do
      expect(response).to be_success
    end
    it 'should render form' do
      expect(response).to render_template(:new)
      expect(response).to render_template("analyses/_form")
    end
    it 'should ask for a research question' do
      expect(response.body).to include(research_question_survival.name)
    end
    it 'should ask for a dataset' do
      expect(response.body).to include(dataset.name)
    end
  end
end
