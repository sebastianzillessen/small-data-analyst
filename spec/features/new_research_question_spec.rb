require 'rails_helper'

describe "creating a new research question" do
  let(:admin) { create(:admin) }
  before(:each) { login_user(admin) }

  before(:each) { visit '/research_questions/new' }
  it 'should require a name' do
    click_on_submit
    expect(current_path).to eq "/research_questions"
    expect(page).to have_content "can't be blank"
  end

  it 'should require a name' do
    fill_in "Name", with: "Testit"
    click_on_submit
    expect(current_path).to eq research_question_path(ResearchQuestion.last)
    expect(ResearchQuestion.last.name).to eq "Testit"
  end
end