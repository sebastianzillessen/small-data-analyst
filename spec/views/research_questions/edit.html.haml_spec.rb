require 'rails_helper'

RSpec.describe "research_questions/edit", type: :view do
  before(:each) do
    @research_question = assign(:research_question, FactoryGirl.create(:research_question))
  end

  it "renders the edit research_question form" do
    render

    assert_select "form[action=?][method=?]", research_question_path(@research_question), "post" do

      assert_select "input#research_question_name[name=?]", "research_question[name]"

      assert_select "textarea#research_question_description[name=?]", "research_question[description]"

      assert_select "input#research_question_private[name=?]", "research_question[private]"
    end
  end
end
