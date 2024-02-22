require "rails_helper"

RSpec.describe "Admin Dashboard", type: :feature do
  before do
    # As an Admin
    # When I visit the admin dashboard (/admin)
    visit "/admin"
  end

  describe "As an admin" do
    
    # 19. Admin Dashboard
    it "displays an 'Admin' page header" do
      # Then I see a header indicating that I am on the admin dashboard
      expect(page).to have_content("Admin Dashboard")
    end
  end

  #20. Admin Dashboard Links
  describe "page links" do
    # Then I see a link to the admin merchants index (/admin/merchants)
    it "displays a merchant link"  do
      expect(page).to have_link("merchants")
      click_on "merchants"
      expect(current_path).to eq(admin_merchants_path)
    end

    # And I see a link to the admin invoices index (/admin/invoices)
    it "displays a invoice link" do
      expect(page).to have_link("invoices")
      click_on "invoices"
      expect(current_path).to eq(admin_invoices_path)
    end
  end
end