require 'rails_helper'

describe "creating a new analysis" do
  let(:admin) { create(:admin) }
  before(:each) { login_user(admin) }

  it 'should be logged in' do
    visit root_path
    expect(page).to have_content 'Analysis'
    expect(page).to have_content 'Research Questions'
    expect(page).to have_content 'Models'
    expect(page).to have_content 'Datasets'
    expect(page).to have_content "Log out (#{admin.email})"
  end
end