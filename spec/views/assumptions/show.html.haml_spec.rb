require 'rails_helper'


RSpec.describe "assumptions/show", type: :view do
  subject { FactoryGirl.create(:blank_assumption) }
  # todo test other types
  before(:each) do
    @assumption = assign(:assumption, subject)
  end

  let(:user) { create(:user) }
  before(:each) { allow(controller).to receive(:current_user).and_return(user) }


  it "renders attributes in <p>" do
    render
    expect(rendered).to match(subject.name)
  end
end
