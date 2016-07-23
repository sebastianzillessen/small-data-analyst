require 'rails_helper'

describe "creating a new analysis" do
  let(:admin) { create(:admin) }
  before(:each) { login_user(admin) }
  let!(:dataset) { create(:dataset_survival) }
  let!(:model) { create(:model_with_query_test_assumption) }


  describe 'show analysis with a test query plot', js: true do
    subject { create(:analysis, dataset: dataset, research_question: model.research_questions.first, user: create(:statistician)) }

    before(:each) {
      visit analysis_path(subject)
    }
    it 'should show 1 possible model' do
      expect(page).to have_content(model.name)
    end

    it 'should have 1 open query assumptions and 1 possible models' do
      within '#open_questions' do
        expect(page).to have_css("li.query_assumption_result", count: 1)
      end
      within '#possible_models' do
        expect(page).to have_content(model.name)
      end
    end

    it '"No" on first query' do

      within '#open_questions' do
        form = find("form.query_assumption_result")
        expect(page).to have_css ("img.fit-parent")
        # answer question
        within form do
          click_link "No"
        end
        form_id = "##{form[:id]}"
        # check that form was removed
      end
      wait_for_ajax
      expect(page).not_to have_css('#open_questions')

      # test for possbile models
      within '#possible_models_as_1' do
        expect(page).not_to have_content(model.name)
      end
    end

    it '"YES" on first query' do

      within '#open_questions' do
        form = find("form.query_assumption_result")
        expect(page).to have_css ("img.fit-parent")
        # answer question
        within form do
          click_link "Yes"
        end
        form_id = "##{form[:id]}"
        # check that form was removed
      end
      wait_for_ajax
      expect(page).not_to have_css('#open_questions')

      # test for possbile models
      within '#possible_models_as_1' do
        expect(page).to have_content(model.name)
      end
    end
  end
end