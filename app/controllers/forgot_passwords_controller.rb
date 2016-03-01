class ForgotPasswordsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_token
      AppMailer.delay.forgot_password_email(user)
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = params[:email].blank? ? "Email cannot be blank." : "There is no user with that email in the system."
      redirect_to forgot_password_path
    end
  end
  
  def confirmation
  end
end
