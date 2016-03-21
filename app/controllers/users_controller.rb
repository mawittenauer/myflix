class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  
  def show
    @user = UserDecorator.decorate(User.find(params[:id]))
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invitation_token])
    if result.successful?
      flash[:success] = "Thank you for registering with MyFlix. Please sign in."
      redirect_to sign_in_path
    else
      flash[:danger] = result.error_message
      render :new
    end
  end
  
  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @invitation_token = invitation.token
      @user = User.new(email: invitation.recipient_email)
      render 'new'
    else
      redirect_to expired_token_path
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:email, :full_name, :password)
  end
end
