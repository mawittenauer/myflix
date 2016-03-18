class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.valid?
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :card => params[:stripeToken],
        :description => "Sign up charge for #{@user.email}"
      )
      if charge.successful?
        @user.save
        handle_invitation
        AppMailer.delay.welcome_email(@user)
        flash[:success] = "Thank you for registering with MyFlix. Please sign in."
        redirect_to sign_in_path
      else
        flash.now[:danger] = charge.error_message
        render 'new'
      end
    else
      flash.now[:danger] = "Invalid user information. Please check the errors."
      render 'new'
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
    params.require(:user).permit(:email, :full_name, :password, :stripeToken)
  end
  
  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by(token: params[:invitation_token])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_attribute(:token, nil)
    end
  end
end
