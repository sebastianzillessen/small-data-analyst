require 'rails_helper'

RSpec.describe "research_questions/new", type: :view do
  before(:each) do
    assign(:research_question, ResearchQuestion.new(
      :name => "MyString",
      :description => "MyText",
      :private => false
    ))
  end

  it "renders new research_question form" do
    render

    assert_select "form[action=?][method=?]", research_questions_path, "post" do

      assert_select "input#research_question_name[name=?]", "research_question[name]"

      assert_select "textarea#research_question_description[name=?]", "research_question[description]"

      assert_select "input#research_question_private[name=?]", "research_question[private]"
    end
  end
end
