module DeviseRequestSpecHelpers

  # for use in request specs
  def login_user
    @user ||= FactoryGirl.create :user
    @user.confirm
    post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @user.password
  end

end