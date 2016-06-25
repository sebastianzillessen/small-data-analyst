module DeviseRequestSpecHelpers

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
    post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @user.password
  end

end