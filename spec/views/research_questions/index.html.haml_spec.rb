require 'rails_helper'

RSpec.describe "research_questions/index", type: :view do
  subject{FactoryGirl.create_list(:research_question, 2)}
  before(:each) do
    assign(:research_questions, subject)
  end

  it "renders a list of research_questions" do
    render
    assert_select "tr>td", :text => subject.first.name
    assert_select "tr>td", :text => subject.last.name
  end
end
