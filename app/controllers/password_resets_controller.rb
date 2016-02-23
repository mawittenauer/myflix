class PasswordResetsController < ApplicationController

  def show
    user = User.find_by(token: params[:id])
    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end
  
  def create
    user = User.find_by(token: params[:token])
    if user
      user.password = params[:password]
      @token = user.token
      if user.save
        user.delete_token
        flash[:success] = "Your password has been changed. Please sign in."
        redirect_to sign_in_path
      else
        flash.now[:danger] = "That is an invalid password, please make sure it is not blank and meets the password requirements."
        render 'show'
      end
    else
      redirect_to expired_token_path
    end
  end
  
end
