require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index', type: :feature do
  before do
    @barry = Merchant.create!(name: "Barry")
    @ten_percent = BulkDiscount.create!(name: "10% Off", percentage: 10, quantity_threshold: 3, merchant_id: @barry.id)
    @twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 20, quantity_threshold: 5, merchant_id: @barry.id)
    @thirty_percent = BulkDiscount.create!(name: "30% Off", percentage: 30, quantity_threshold: 8, merchant_id: @barry.id)
    visit merchant_bulk_discounts_path(@barry.id)
  end

  describe "User Story 1 - Index Setup" do
    it "lists all bulk discounts with their discount and quantity threshold along with link to the show page" do
      expect(page).to have_content("All of Barry's Bulk Discounts")
      within "#discount-#{@ten_percent.id}" do
        expect(page).to have_content("10% Off")
        expect(page).to have_content("Discount: 10%")
        expect(page).to have_content("Quantity Threshold: 3")
      end
      within "#discount-#{@twenty_percent.id}" do
        expect(page).to have_content("20% Off")
        expect(page).to have_content("Discount: 20%")
        expect(page).to have_content("Quantity Threshold: 5")
      end
      within "#discount-#{@thirty_percent.id}" do
        expect(page).to have_content("30% Off")
        expect(page).to have_content("Discount: 30%")
        expect(page).to have_content("Quantity Threshold: 8")

      end
    end
  end
end
