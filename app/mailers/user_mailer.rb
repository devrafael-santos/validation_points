class UserMailer < ApplicationMailer
  def user_created(user)
    @user = user
    mail(to: @user.email, subject: "Bem-vindo ao Validation Points!")
  end
end
