class AppMailer < ActionMailer::Base
  
  def welcome_email(user)
    @user = user
    mail from: "info@myflix.com", to: user.email, subject: "Welcome to MyFlix!"
  end
  
  def forgot_password_email(user)
    @user = user
    mail from: "infor@myflix.com", to: user.email, subject: "Please reset your password"
  end
  
end
