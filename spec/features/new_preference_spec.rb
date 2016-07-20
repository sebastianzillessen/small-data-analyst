require 'rails_helper'

describe "creating a new preference" do
  let(:admin) { create(:admin) }
  let!(:research_question) { create(:research_question_with_model) }
  let!(:test_assumption) { create(:test_assumption) }
  before(:each) { login_user(admin) }

  before(:each) { visit '/preferences/new' }

  it 'should show reseach question selection firt', js: true do
    expect(page).to have_content "Research question"
    expect(page).not_to have_content "Name"
    select_from_chosen(research_question.name, from: '#preference_research_question_id')
    click_on "Proceed to next step"
    expect(page).to have_content research_question.name
    fill_in "Name", with: "Foo"
    fill_in "Priority", with: 1
    check "Global"
    select_from_chosen(test_assumption.name, from: '#preference_preference_arguments_attributes_0_assumption_id')
    # TODO: Test for moving and arranging models.
    #find('.label', text: research_question.models.first.name).drag_to(find('#target'))
    #click_on "Create preference"
    #expect(current_path).to eq preference_path(Preference.last)
  end


end