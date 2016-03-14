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
    
    if @user.save
      handle_invitation
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      Stripe::Charge.create({
        :amount => 999,
        :currency => "usd",
        :source => params[:stripeToken],
        :description => "Sign up charge for #{@user.email}"
      })
      
      StripeWrapper::Charge.create(
        
        )
      AppMailer.delay.welcome_email(@user)
      redirect_to sign_in_path
    else
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
    params.require(:user).permit(:email, :full_name, :password)
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
