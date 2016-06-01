require 'rails_helper'

RSpec.describe "assumptions/new", type: :view do
  before(:each) do
    assign(:assumption, Assumption.new(
      :name => "MyString",
      :description => "MyText",
      :critical => false,
      :fail_on_missing => false,
      :r_code => "MyText",
      :question => "MyText",
      :argument_inverted => false
    ))
  end

  it "renders new assumption form" do
    render

    assert_select "form[action=?][method=?]", assumptions_path, "post" do

      assert_select "input#assumption_name[name=?]", "assumption[name]"

      assert_select "textarea#assumption_description[name=?]", "assumption[description]"

      assert_select "input#assumption_critical[name=?]", "assumption[critical]"

      assert_select "textarea#assumption_required_dataset_fields[name=?]", "assumption[required_dataset_fields]"

      assert_select "input#assumption_fail_on_missing[name=?]", "assumption[fail_on_missing]"

      assert_select "textarea#assumption_r_code[name=?]", "assumption[r_code]"

      assert_select "textarea#assumption_question[name=?]", "assumption[question]"

      assert_select "input#assumption_argument_inverted[name=?]", "assumption[argument_inverted]"
    end
  end
end
