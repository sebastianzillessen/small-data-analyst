require 'rails_helper'

RSpec.describe "datasets/show", type: :view do
  before(:each) do
    @dataset = assign(:dataset, create(:dataset))
  end
  let(:user) { create(:user) }
  before(:each) { allow(controller).to receive(:current_user).and_return(user) }


  it "renders attributes in <p>" do
    render
  end
end
