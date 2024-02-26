require "rails_helper"

RSpec.describe "Admin Merchants New", type: :feature do
  describe "As an admin" do
    before do
      visit new_admin_merchant_path
    end

    it "Displays new merchant form" do
      expect(page).to have_field("Name")
    end

    it "redirects completed form to admin merchants index" do
      fill_in "Name", with: "The Amazing Merchant"
      click_on "Submit"

      expect(current_path).to eq(admin_merchants_path)
      expect(page).to have_content("The Amazing Merchant")
    end

    it "New merchant is 'disabled' by default" do
      fill_in "Name", with: "The Amazing Merchant"
      click_on "Submit"

      expect(current_path).to eq(admin_merchants_path)
   
      within "#disabled-merchants" do
        expect(page).to have_content("The Amazing Merchant")
      end
    end
  end
end