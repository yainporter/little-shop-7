require "rails_helper"

RSpec.describe "Admin Dashboard", type: :feature do
  describe "As a visitor" do
    before do
      # When I visit the admin dashboard (/admin)
      visit "/admin"
    end
    
    # 19. Admin Dashboard
    it "displays an 'Admin' page header" do
      # As an admin,
      # Then I see a header indicating that I am on the admin dashboard
      expect(page).to have_content("Admin Dashboard")
    end

  #20. Admin Dashboard Links
  describe "page links" do
    it "displays a merchant link"  do
      
      expect(page).to have_link("merchant")
      click_on "merchant"
      expect(current_path).to be("/admin/merchants")
    end

    it "displays a invoice link" do
      
      expect(page).to have_link("invoice")
      click_on "invoice"
      expect(current_path).to be("/admin/invoices")
      
    end
  end
end