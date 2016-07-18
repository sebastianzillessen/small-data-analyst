module FeatureLoginHelper

  # for use in request specs
  def login_user(factory = :user)
    @user ||= if (factory.is_a? Symbol)
                FactoryGirl.create factory
              else
                factory
              end
    @user.confirm
    @user.approved = true
    @user.save

    expect(@user).to be_valid
    visit new_user_session_path
    fill_in 'user_email', :with => @user.email
    fill_in 'user_password', :with => @user.password
    click_on_submit
    expect(page).to have_content "Signed in successfully."
  end

end