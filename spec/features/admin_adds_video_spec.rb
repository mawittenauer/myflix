require 'spec_helper'

feature "admin adds a video" do
  scenario "admin user adds a new video" do
    admin = Fabricate(:admin)
    dramas = Fabricate(:category, name: "Dramas")
    sign_in(admin)
    
    admin_creates_video
    
    sign_out
    sign_in
    
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com']")
    
  end
  
  def admin_creates_video
    visit new_admin_video_path
    fill_in "Title", with: "Monk"
    select "Dramas", from: "Category"
    fill_in "Description", with: "SF detective"
    attach_file "Large cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small cover", "spec/support/uploads/monk.jpg"
    fill_in "Video URL", with: "http://www.example.com"
    click_button "Add Video"
  end
end
