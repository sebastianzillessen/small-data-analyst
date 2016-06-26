require 'rails_helper'

RSpec.describe "models/edit", type: :view do
  let(:user) { create(:user) }
  before(:each) { allow(controller).to receive(:current_user).and_return(user) }

  before(:each) do
    @model = FactoryGirl.create(:model)
  end

  it "renders the edit model form" do
    render

    assert_select "form[action=?][method=?]", model_path(@model), "post" do

      assert_select "input#model_name[name=?]", "model[name]"

      assert_select "textarea#model_description[name=?]", "model[description]"
    end
  end
end
