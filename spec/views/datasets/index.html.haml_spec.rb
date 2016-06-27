require 'rails_helper'

RSpec.describe "datasets/index", type: :view do
  let(:user) { create(:user) }
  before(:each) { allow(controller).to receive(:current_user).and_return(user) }

  before(:each) do
    assign(:datasets, create_list(:dataset, 2))
  end

  it "renders a list of datasets" do
    render
  end
end
