require 'rails_helper'

RSpec.describe "models/new", type: :view do
  before(:each) do
    assign(:model, Model.new(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new model form" do
    render

    assert_select "form[action=?][method=?]", models_path, "post" do

      assert_select "input#model_name[name=?]", "model[name]"

      assert_select "textarea#model_description[name=?]", "model[description]"
    end
  end
end
