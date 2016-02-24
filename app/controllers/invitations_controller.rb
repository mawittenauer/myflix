class InvitationsController < ApplicationController
  before_action :require_user
  
  def new
    @invitation = Invitation.new
  end
  
  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
    if @invitation.save
      AppMailer.invitation_email(@invitation).deliver
      flash[:success] = "You have successfully invited #{@invitation.recipient_name}."
      redirect_to new_invitation_path
    else
      flash.now[:danger] = "Please check that your inputs are correct."
      render 'new'
    end
  end
  
  def new_with_invitation_token
    
  end
  
  private
  def invitation_params
    params.require(:invitation).permit(:recipient_email, :recipient_name, :message)
  end
end