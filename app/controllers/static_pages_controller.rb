class StaticPagesController < ApplicationController
  def front_page
    redirect_to home_path if current_user
  end
  
  def expired_token
  end
end
