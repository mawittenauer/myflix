require 'spec_helper'

feature "User invites a friend" do
  scenario "User successfully invites friend and invitation is accepted" do
    alice = Fabricate(:user)
    sign_in(alice)
    
    invite_a_friend
    friend_accepts_invitation
    
    friend_signs_in
    
    friend_should_follow(alice)
    
    inviter_should_follow_friend(alice)
    
    clear_email
  end
  
  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "Mike Wittenauer"
    fill_in "Friend's Email Address", with: "mike@example.com"
    fill_in "Message", with: "Hello! Join MyFlix!"
    click_button "Send Invitation"
    sign_out
  end
  
  def friend_accepts_invitation
    open_email("mike@example.com")
    current_email.click_link "Sign Up Now!"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Mike Wittenauer"
    click_button "Sign Up"
  end
  
  def friend_signs_in
    fill_in "Email", with: "mike@example.com"
    fill_in "Password", with: "password"
    click_button "Sign In"
  end
  
  def friend_should_follow(user)
    click_link "People"
    expect(page).to have_content user.full_name
    sign_out
  end
  
  def inviter_should_follow_friend(inviter)
    sign_in(inviter)
    click_link "People"
    expect(page).to have_content "Mike Wittenauer"
  end
end
