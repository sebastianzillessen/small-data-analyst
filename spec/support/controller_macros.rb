module ControllerMacros
  def login_user(factory=:user)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = if (factory.is_a? User)
                factory
              else
                FactoryGirl.create(factory)
              end
      @user.confirm # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      @user.approved = true
      @user.save
      sign_in @user
    end
  end

  def login_admin
    login_user(:admin)
  end

  def login_clinician
    login_user(:clinician)
  end

  def login_statistician
    login_user(:statistician)
  end
end