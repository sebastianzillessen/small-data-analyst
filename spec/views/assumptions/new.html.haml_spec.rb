require 'rails_helper'

RSpec.describe "assumptions/new", type: :view do
  describe 'BlankAssumption' do
    before(:each) do
      @assumption = FactoryGirl.create(:blank_assumption)
      # todo: test for other assumption types
    end

    it "renders the edit assumption form" do
      render

      assert_select "form[action=?][method=?]", assumption_path(@assumption), "post" do
        assert_select "input#blank_assumption_name[name=?]", "blank_assumption[name]"
        assert_select "textarea#blank_assumption_description[name=?]", "blank_assumption[description]"
      end
    end
  end

  describe 'QueryAssumption' do
    before(:each) do
      @assumption = FactoryGirl.create(:query_assumption)
    end

    it "renders the edit assumption form" do
      render

      assert_select "form[action=?][method=?]", assumption_path(@assumption), "post" do
        assert_select "input#query_assumption_name[name=?]", "query_assumption[name]"
        assert_select "textarea#query_assumption_description[name=?]", "query_assumption[description]"
        assert_select "textarea#query_assumption_question[name=?]", "query_assumption[question]"

      end
    end
  end
  describe 'TestAssumption' do
    before(:each) do
      @assumption = FactoryGirl.create(:test_assumption)
    end

    it "renders the edit assumption form" do
      render

      assert_select "form[action=?][method=?]", assumption_path(@assumption), "post" do
        assert_select "input#test_assumption_name[name=?]", "test_assumption[name]"
        assert_select "textarea#test_assumption_description[name=?]", "test_assumption[description]"
        assert_select "input#test_assumption_type[name=?]", "test_assumption[type]"
        assert_select "input#test_assumption_required_dataset_fields[name=?]", "test_assumption[required_dataset_fields][]"
        assert_select "textarea#test_assumption_r_code[name=?]", "test_assumption[r_code]"

      end
    end
  end
end
