class AppMailer < ActionMailer::Base
  
  default from: "info@myflix.com"
  
  def welcome_email(user)
    @user = user
    mail to: user.email, subject: "Welcome to MyFlix!"
  end
  
  def forgot_password_email(user)
    @user = user
    mail to: user.email, subject: "Please reset your password"
  end
  
  def invitation_email(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email, subject: "Invitation to join Myflix"
  end
  
end
