require "rails_helper"

RSpec.describe "Merchant Dashboard" do
  before do
    @merchant_1 = Merchant.create!(name: "Barry")

    visit "/merchants/#{@merchant_1.id}/dashboard"
  end

  describe "User Story 1 - Merchant Dashboard" do
    it "displays merchant name" do
      expect(page).to have_content("Barry's Dashboard")
    end
  end

  describe "User Story 2 - Merchant Dashboard Links" do
    it "has links to Merchant's items index and invoices index" do
      expect(page).to have_link("Barry's Items")

      click_link("Barry's Items")
      expect(page.current_path).to eq("/merchants/#{@merchant_1.id}/items")

      visit "/merchants/#{@merchant_1.id}/dashboard"
      expect(page).to have_link("Barry's Invoices")

      click_link("Barry's Invoices")
      expect(page.current_path).to eq("/merchants/#{@merchant_1.id}/invoices")
    end
  end
end
