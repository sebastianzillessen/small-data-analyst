require 'rails_helper'

RSpec.describe "research_questions/show", type: :view do
  subject { FactoryGirl.create(:research_question) }
  let(:user) { create(:user) }
  before(:each) { allow(controller).to receive(:current_user).and_return(user) }

  before(:each) do
    @research_question = assign(:research_question, subject)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to include(subject.name)
    expect(rendered).to include(subject.description)
    subject.models.each do |m|
      expect(rendered).to include(m.name)
    end

  end
end
