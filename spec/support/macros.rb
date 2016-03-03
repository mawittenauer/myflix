def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def sign_in(a_user = nil)
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign In"
end

def sign_out
  click_link "Sign Out"
end

def set_current_admin(admin=nil)
  session[:user_id] = (admin || Fabricate(:admin))
end
