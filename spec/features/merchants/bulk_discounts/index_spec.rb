require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index', type: :feature do
  before do
    @barry = Merchant.create!(name: "Barry")
    @ten_percent = BulkDiscount.create!(name: "10% Off", percentage: 0.1, quantity_threshold: 3, merchant_id: @barry.id)
    @twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 0.2, quantity_threshold: 5, merchant_id: @barry.id)
    @thirty_percent = BulkDiscount.create!(name: "30% Off", percentage: 0.3, quantity_threshold: 8, merchant_id: @barry.id)
    visit merchant_bulk_discounts_path(@barry.id)
  end

  describe "User Story 1 - Index Setup" do
    it "lists all bulk discounts with their discount and quantity threshold along with link to the show page" do
      save_and_open_page
      expect(page).to have_content("All of Barry's Bulk Discounts")
      expect(page).to have_content("10% Off")
      expect(page).to have_content("20% Off")
      expect(page).to have_content("30% Off")
    end
  end
end
