class AdminMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.new_user_waiting_for_approval.subject
  #
  def new_user_waiting_for_approval(user)
    @user = user
    mail bcc: User.admins.map(&:email) << 'sebastian@zillessen.info'
  end
end
