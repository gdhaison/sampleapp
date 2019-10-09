class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t(".acount")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t(".reset")
  end
end
