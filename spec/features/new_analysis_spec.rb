require 'rails_helper'

describe "creating a new analysis" do
  let(:admin) { create(:admin) }
  before(:each) { login_user(admin) }
  let!(:dataset) { create(:dataset_survival) }
  let!(:research_question_survival) { create(:research_question) }


  describe 'with js support', js: true do
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


  it "signs me in" do
    skip("test")
    visit '/sessions/new'
    within("#session") do
      fill_in 'Email', :with => 'user@example.com'
      fill_in 'Password', :with => 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Success'
  end
end