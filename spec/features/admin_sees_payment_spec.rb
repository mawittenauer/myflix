require 'spec_helper'

feature 'Admin sees payments' do
  background do
    alice = Fabricate(:user, full_name: "Alice Doe")
    Fabricate(:payment, amount: 999, user: alice)
  end
  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Alice Doe")
  end
  scenario "user cannot see payments" do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).to_not have_content("Alice Doe")
    expect(page).to have_content("You don't have access to that.")
  end
end
