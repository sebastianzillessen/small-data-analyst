require 'rails_helper'

RSpec.describe "assumptions/edit", type: :view do
  before(:each) do
    @assumption = FactoryGirl.create(:assumption)
  end

  it "renders the edit assumption form" do
    render

    assert_select "form[action=?][method=?]", assumption_path(@assumption), "post" do

      assert_select "input#assumption_name[name=?]", "assumption[name]"

      assert_select "textarea#assumption_description[name=?]", "assumption[description]"

      assert_select "input#assumption_critical[name=?]", "assumption[critical]"

      assert_select "input#assumption_type[name=?]", "assumption[type]"

      assert_select "textarea#assumption_required_dataset_fields[name=?]", "assumption[required_dataset_fields]"

      assert_select "input#assumption_fail_on_missing[name=?]", "assumption[fail_on_missing]"

      assert_select "textarea#assumption_r_code[name=?]", "assumption[r_code]"

      assert_select "input#assumption_mandatory_type[name=?]", "assumption[mandatory_type]"

      assert_select "textarea#assumption_question[name=?]", "assumption[question]"

      assert_select "input#assumption_argument_inverted[name=?]", "assumption[argument_inverted]"
    end
  end
end
