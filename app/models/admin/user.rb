class Admin::User < User

  private

  def password_required?
    new_record? ? false : super
  end


end