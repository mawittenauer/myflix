require "spec_helper"

feature "user resets password" do
  scenario "user successfully resets the password" do
    mike = Fabricate(:user, password: "old_password", email: "mike@example.com", full_name: "Mike Wittenauer")
    
    visit sign_in_path
    click_link "Forgot Password?"
    
    fill_in "email", with: "mike@example.com"
    click_button 'Send Email'
    
    open_email('mike@example.com')
    
    current_email.click_link 'Reset My Password'
    
    fill_in 'New Password', with: "new_password"
    click_button 'Reset Password'
    
    fill_in 'email', with: 'mike@example.com'
    fill_in 'password', with: 'new_password'
    click_button 'Sign In'
    
    expect(page).to have_content "Mike Wittenauer"
  end
end
