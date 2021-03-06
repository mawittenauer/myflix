class SessionsController < ApplicationController
  
  def new
    redirect_to home_path if current_user  
  end
  
  def create
    user = User.find_by(email: params[:email])
    
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You have signed in, enjoy!"
      redirect_to home_path
    else
      flash.now[:danger] = "There was something wrong with your username or password."
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:success] = "You have successfully logged out."
    redirect_to root_path
  end
end
