require 'spec_helper'

feature "User Signs Up", { vcr: true, js: true } do
  background do
    visit register_path
  end
  scenario "with valid user info and valid card" do
    fill_in_user("john@example.com", "123456", "John Doe")
    fill_in_credit_card("4242424242424242")
    click_button "Sign Up"
    expect(page).to have_content("Thank you for registering with MyFlix. Please sign in.")
  end
  scenario "with valid user info and invalid card" do
    fill_in_user("john@example.com", "123456", "John Doe")
    fill_in_credit_card("123")
    click_button "Sign Up"
    expect(page).to have_content("The card number is not a valid credit card number.")
  end
  scenario "with valid user info and declined card" do
    fill_in_user("john@example.com", "123456", "John Doe")
    fill_in_credit_card("4000000000000002")
    click_button "Sign Up"
    expect(page).to have_content("Your card was declined.")
  end
  scenario "with invalid user info and valid card" do
    fill_in_user("", "123456", "John Doe")
    fill_in_credit_card("4242424242424242")
    click_button "Sign Up"
    expect(page).to have_content("Invalid user information. Please check the errors.")
  end
  scenario "with invalid user info and invalid card" do
    fill_in_user("", "123456", "John Doe")
    fill_in_credit_card("123")
    click_button "Sign Up"
    expect(page).to have_content("The card number is not a valid credit card number.")
  end
  scenario "with invalid user info and declined card" do
    fill_in_user("", "123456", "John Doe")
    fill_in_credit_card("4000000000000002")
    click_button "Sign Up"
    expect(page).to have_content("Invalid user information. Please check the errors.")
  end
  
  def fill_in_user(email, password, name)
    fill_in "Email Address", with: email
    fill_in "Password", with: password
    fill_in "Full Name", with: name
  end
  
  def fill_in_credit_card(cardnumber)
    fill_in "Credit Card Number", with: cardnumber
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2018", from: "date_year"
  end
end
