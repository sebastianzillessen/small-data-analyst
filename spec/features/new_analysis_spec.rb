require 'rails_helper'

describe "creating a new analysis" do
  let(:admin) { create(:admin) }
  before(:each) { login_user(admin) }
  let!(:dataset) { create(:dataset_survival) }
  let!(:research_question_survival) { create(:research_question_survival) }

  let!(:cd1){create(:preference_cd1, research_question: research_question_survival)}
  let!(:cd2){create(:preference_cd2, research_question: research_question_survival)}


  describe 'with js support', js: true do
    describe 'new analysis' do
      before(:each) { visit '/analyses/new' }

      it 'should find field input fields' do
        find('#analysis_research_question_id', visible: false)
        find('#analysis_dataset_id', visible: false)
      end


      it 'should select attributes and create a new analysis' do
        expect {
          within("#new_analysis") do
            select_from_chosen(research_question_survival.name, from: '#analysis_research_question_id')
            select_from_chosen(dataset.name, from: '#analysis_dataset_id')
            click_on_submit
          end
          expect(page).to have_content "Analysis was successfully created."
        }.to change {
          Analysis.count
        }.by(1)
      end

      it 'should not allow an empty analysis to be created' do
        click_on_submit
        expect(page).to have_content("can't be blank", count: 2)
      end
    end

    describe 'show analysis' do
      subject { create(:analysis, dataset: dataset, research_question: research_question_survival) }

      describe 'with 2 possible models at the beginning and as3 not holding' do
        before(:each) {
          visit analysis_path(subject)
        }
        it 'should contain possible models' do
          expect(page).to have_content 'Currently Possible Models'
          expect(page).not_to have_content 'Recommended Models'
          expect(page).to have_content 'Open Query Assumptions'
          expect(page).to have_content 'Extended Argumentation Framework used to evaluate preferences'
          expect(page).not_to have_content("Possible Models after AS1")
        end

        it 'should have 1 open query assumptions and 2 possible models' do
          within '#open_questions' do
            expect(page).to have_css("li.query_assumption_result", count: 1)
          end
          within '#possible_models' do
            expect(page).to have_content("Weibull")
            expect(page).to have_content("Kaplan Meier")
          end
          expect(page).not_to have_css('#possible_models_as_1')
        end

        it '"No" on first query' do
          visit analysis_path(subject)

          within '#open_questions' do
            form = find("form.query_assumption_result")
            # answer question
            within form do
              click_link "No"
            end
            form_id = "##{form[:id]}"
            # check that form was removed
          end
          expect(page).not_to have_css('#open_questions')

          # test for flash note
          expect(page).to have_content "'non informative censoring' has been answered with 'No'."
          expect(page).to have_content "Analysis is now complete."

          # test for answered question and icons
          within '#answered_questions_parent' do
            expect(page).to have_content "non informative censoring"
            expect(page).to have_css ".glyphicon.glyphicon-remove-sign.text-danger"
          end

          # test for possbile models
          expect(page).to have_content("Possible Models after AS1")
          within '#possible_models_as_1' do
            expect(page).not_to have_content("Weibull")
            expect(page).not_to have_content("Kaplan Meier")
            expect(page).to have_content("No possible models found")
          end
          expect(subject.open_query_assumptions.count).to eq 0


          expect(page).not_to have_css('#open_questions')

          within '#ignored_questions_parent' do
            expect(page).to have_content("No ignored query assumptions.")
          end

          within '#remaining_models_parent' do
            expect(page).to have_content('Recommended models')
            expect(page).not_to have_content("Weibull")
            expect(page).not_to have_content("Kaplan Meier")
            expect(page).not_to have_content("Cox Proportional")
            expect(page).to have_content("No possible models found")
          end

          within '#detailed_model_view' do
            expect(page).to have_css(".list-group-item-danger", text: "Kaplan Meier")
            expect(page).to have_css(".list-group-item-danger", text: "Weibull")
            expect(page).to have_css(".list-group-item-danger", text: "Cox Proportional Hazard")
            expect(page).to have_css(".list-group-item-danger", text: "Rejected in: AS1", count: 3)
            expect(page).to have_css(".list-group-item-heading.text-danger", text: "a1", count: 2)
            expect(page).to have_css(".list-group-item-heading.text-danger", text: "a3", count: 1)
          end

          within '#detailed_argumentation_view' do
            expect(page).not_to have_css('img.fit-parent')
            expect(page).to have_content("No Frameworks have been evaluated")
          end
        end

        it 'Yes on first query and only one remainign (so no second answer)' do
          expect(page).not_to have_content("Possible Models after AS1")

          within '#open_questions' do
            form = find("form.query_assumption_result")
            # answer question
            within form do
              click_link "Yes"
            end
          end

          # test for flash note
          expect(page).to have_content "has been answered with 'Yes'."

          # test for answered question and icons
          within '#answered_questions_parent' do
            expect(page).to have_content 'a1: non informative censoring'
            expect(page).to have_css ".glyphicon.glyphicon-ok-sign.text-success"
          end

          # test for possbile models
          expect(page).to have_content("Possible Models after AS1")
          within '#possible_models_as_1' do
            expect(page).to have_content("Weibull")
            expect(page).to have_content("Kaplan Meier")
            expect(page).not_to have_content("Cox")
          end
          expect(subject.open_query_assumptions.count).to eq 0

          expect(page).to have_content("Analysis is now complete.")
          expect(page).not_to have_css('#open_questions')
          expect(page).not_to have_css('form.query_assumption_result')
          within '#ignored_questions_parent' do
            expect(page).to have_content("No ignored query assumptions")
          end

          expect(page).to have_content('Recommended models')

          within '#detailed_model_view' do
            expect(page).to have_css(".list-group-item-success", text: "Kaplan Meier")
            expect(page).to have_css(".list-group-item-danger", text: "Weibull")
            expect(page).to have_css(".list-group-item-danger", text: "Cox Proportional Hazard")
            expect(page).to have_css(".list-group-item-danger", text: "Rejected in: AS1")
            expect(page).to have_css(".list-group-item-danger", text: "Rejected in: AS2")
            subject.remaining_models.each do |m|
              within "#model_#{m.id}" do
                expect(page).to have_css('.list-group-item-heading.text-success', count: m.assumptions.count)
                expect(page).to have_css('.list-group-item-heading.text-success', text: "a1")
                expect(page).to have_css('.list-group-item-heading.text-success', text: "a2")
              end
            end

            expect(page).to have_css('.list-group-item-danger .text-success', text: "CD1_mild")
            expect(page).to have_css('.list-group-item-danger .text-danger', text: "a3")
          end

          within '#detailed_argumentation_view' do
            expect(page).to have_css('img.fit-parent', count: 1)
          end


          expect(subject).to be_done
        end
      end


      describe 'with all 3 models beeing possible at the beginning' do
        before(:each) {
          TestAssumption.find_by(name: "a3").update_attributes(r_code: "result <- TRUE")
          DatasetTestAssumptionResult.destroy_all
          visit analysis_path(subject)
        }
        it 'Yes on first query, then CD2_explain on AS2' do
          expect(subject.open_query_assumptions.count).to eq 1
          expect(subject.possible_models.count).to eq 3

          qa = subject.open_query_assumptions.first.query_assumption


          within '#open_questions' do
            form = find("form.query_assumption_result")
            # answer question
            within form do
              click_link "Yes"

            end
            form_id = "##{form[:id]}"
            # check that form was removed
            expect(page).not_to have_css(form_id)
          end

          # test for flash note
          expect(page).to have_content "has been answered with 'Yes'."

          # test for answered question and icons
          within '#answered_questions_parent' do
            expect(page).to have_content qa.name
            expect(page).to have_css ".glyphicon.glyphicon-ok-sign.text-success"
          end

          # test for possbile models
          expect(page).to have_content("Possible Models after AS1")
          within '#possible_models_as_1' do
            expect(page).to have_content("Weibull")
            expect(page).to have_content("Kaplan Meier")
            expect(page).to have_content("Cox Proportional Hazard")
          end
          expect(subject.open_query_assumptions.count).to eq 2

          expect(page).to have_content("'non informative censoring' has been answered with 'Yes'.")

          query_assumptions_for_cd2 = subject.open_query_assumptions.map(&:query_assumption)
          expect(query_assumptions_for_cd2.select { |qa| qa.name.start_with?("CD2_") }.length).to be(2)

          Capybara::Screenshot.screenshot_and_save_page

          within '#open_questions' do
            expect(page).to have_css("form.query_assumption_result", count: 2)
            within "#query_assumption_result_#{subject.open_query_assumptions.select { |qa| qa.query_assumption.name == "CD2_explain" }.first.id}" do
              click_link "Yes"
            end
            # should have removed both
          end

          expect(page).not_to have_css('#open_questions')
          expect(page).to have_content("Analysis is now complete.")
          expect(page).not_to have_css('form.query_assumption_result')
          within '#ignored_questions_parent' do
            expect(page).to have_css('.list-group-item .glyphicon.glyphicon-minus-sign.text-muted')
            expect(page).to have_content("CD2_predict")
          end


          within '#remaining_models_parent' do
            expect(page).to have_content('Recommended models')
            expect(page).to have_css('.list-group-item.model', count: 2)
            expect(page).to have_css('.list-group-item.model', text: "Kaplan Meier")
            expect(page).to have_css('.list-group-item.model', text: "Cox Proportional Hazard")
          end

          within '#detailed_model_view' do
            expect(page).to have_css(".list-group-item-success", text: "Kaplan Meier")
            expect(page).to have_css(".list-group-item-success", text: "Cox Proportional Hazard")

            expect(page).to have_css(".list-group-item-danger", text: "Weibull")
            expect(page).to have_css(".list-group-item-danger", text: "Rejected in: AS2")

            subject.remaining_models.each do |m|
              within "#model_#{m.id}" do
                expect(page).to have_css('.list-group-item-heading.text-success', count: m.assumptions.count)
                expect(page).to have_css('.list-group-item-heading.text-success', text: "a1")
                expect(page).to have_css('.list-group-item-heading.text-success', text: "a2")
              end
            end
            subject.declined_models.each do |m|
              within "#model_#{m.id}.list-group-item-danger" do
                expect(page).to have_css('.list-group-item-heading .text-success', count: 1)
                expect(page).to have_css('.list-group-item-heading .text-success', text: "CD1_mild")
              end
            end
          end

          within '#detailed_argumentation_view' do
            expect(page).to have_css('img.fit-parent', count: 2)
          end
        end

        it 'Yes on first query, then CD2_predict on AS2' do
          expect(subject.open_query_assumptions.count).to eq 1
          expect(subject.possible_models.count).to eq 3

          qa = subject.open_query_assumptions.first.query_assumption


          within '#open_questions' do
            form = find("form.query_assumption_result")
            # answer question
            within form do
              click_link "Yes"
            end
            form_id = "##{form[:id]}"
            # check that form was removed
            expect(page).not_to have_css(form_id)
          end

          # test for flash note
          expect(page).to have_content "has been answered with 'Yes'."

          # test for answered question and icons
          within '#answered_questions_parent' do
            expect(page).to have_content qa.name
            expect(page).to have_css ".glyphicon.glyphicon-ok-sign.text-success"
          end

          # test for possbile models
          expect(page).to have_content("Possible Models after AS1")
          within '#possible_models_as_1' do
            expect(page).to have_content("Weibull")
            expect(page).to have_content("Kaplan Meier")
            expect(page).to have_content("Cox Proportional Hazard")
          end
          expect(subject.open_query_assumptions.count).to eq 2

          expect(page).to have_content("'non informative censoring' has been answered with 'Yes'.")

          query_assumptions_for_cd2 = subject.open_query_assumptions.map(&:query_assumption)
          expect(query_assumptions_for_cd2.select { |qa| qa.name.start_with?("CD2_") }.length).to be(2)
          within '#open_questions' do
            expect(page).to have_css("form.query_assumption_result", count: 2)
            within "#query_assumption_result_#{subject.open_query_assumptions.select { |qa| qa.query_assumption.name == "CD2_predict" }.first.id}" do
              click_link "Yes"
            end
            # should have removed both
          end

          expect(page).not_to have_css('#open_questions')
          expect(page).not_to have_css('form.query_assumption_result')
          within '#ignored_questions_parent' do
            expect(page).to have_css('.list-group-item .glyphicon.glyphicon-minus-sign.text-muted')
            expect(page).to have_content("CD2_explain")
          end


          within '#remaining_models_parent' do
            expect(page).to have_content('Recommended models')
            expect(page).to have_css('.list-group-item.model', count: 1)
            #expect(page).to have_css('.list-group-item.model', text: "Kaplan Meier")
            expect(page).to have_css('.list-group-item.model', text: "Cox Proportional Hazard")
          end

          within '#detailed_model_view' do
            expect(page).to have_css(".list-group-item-success", text: "Cox Proportional Hazard")

            expect(page).to have_css(".list-group-item-danger", text: "Weibull")
            expect(page).to have_css(".list-group-item-danger", text: "Rejected in: AS2")
            expect(page).to have_css(".list-group-item-danger", text: "Kaplan Meier")

            subject.remaining_models.each do |m|
              within "#model_#{m.id}" do
                expect(page).to have_css('.list-group-item-heading.text-success', count: m.assumptions.count)
                expect(page).to have_css('.list-group-item-heading.text-success', text: "a1")
                expect(page).to have_css('.list-group-item-heading.text-success', text: "a2")
                expect(page).to have_css('.list-group-item-heading.text-success', text: "a3")
              end
            end
            subject.declined_models.each do |m|
              within "#model_#{m.id}.list-group-item-danger" do
                expect(page).to have_css('.list-group-item-heading .text-success', count: 1)
              end
              expect(page).to have_css('.list-group-item-danger .list-group-item-heading .text-success', text: "CD1_mild")
              expect(page).to have_css('.list-group-item-danger .list-group-item-heading .text-success', text: "CD2_predict")
            end
          end

          within '#detailed_argumentation_view' do
            expect(page).to have_css('img.fit-parent', count: 2)
          end
        end
      end


    end
  end
end