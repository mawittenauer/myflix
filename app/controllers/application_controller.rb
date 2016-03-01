class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  
  def require_user
    redirect_to sign_in_path unless current_user
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id] 
  end
  
  private

  def set_raven_context
    Raven.user_context(user_id: session[:current_user]) # or anything else in session
    Raven.extra_context(params: params.to_hash, url: request.url)
  end
end
