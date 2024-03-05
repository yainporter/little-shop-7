require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Show Page', type: :feature do
  before do
    @barry = Merchant.create!(name: "Barry")
    @ten_percent = BulkDiscount.create!(name: "10% Off", percentage: 10, quantity_threshold: 3, merchant_id: @barry.id)
    @twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 20, quantity_threshold: 5, merchant_id: @barry.id)
    @thirty_percent = BulkDiscount.create!(name: "30% Off", percentage: 30, quantity_threshold: 8, merchant_id: @barry.id)

    visit merchant_bulk_discount_path(@barry, @ten_percent)
  end

  describe "User Story 4 - Merchant Bulk Discount Show" do
    it "displays the Bulk Discount's quantity threshold and percentage discount" do
      expect(page).to have_content("10% Off Stats")
      expect(page).to have_content("Discount: 10%")
      expect(page).to have_content("Quantity Threshold: 3")
    end
  end
end
