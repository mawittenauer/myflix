require 'spec_helper'

feature "user follows another user" do
  let(:mike) { Fabricate(:user) }
  let(:charlie) { Fabricate(:user) }
  
  scenario "user follows and then unfollows someone" do
    sign_in(mike)
    visit user_path(charlie)
    
    click_link "Follow"
    expect(page).to have_content charlie.full_name
    
    click_link "unfollow"
    expect(page).to_not have_content charlie.full_name
  end
end
