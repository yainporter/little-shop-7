require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Show Page', type: :feature do
  before do
    @barry = Merchant.create!(name: "Barry")
    @ten_percent = BulkDiscount.create!(name: "10% Off", percentage: 10, quantity_threshold: 3, merchant_id: @barry.id)

    visit merchant_bulk_discount_path(@barry, @ten_percent)
  end

  describe "User Story 4 - Merchant Bulk Discount Show" do
    it "displays the Bulk Discount's quantity threshold and percentage discount" do
      expect(page).to have_content("10% Off Stats")
      expect(page).to have_content("Discount: 10%")
      expect(page).to have_content("Quantity Threshold: 3")
    end
  end

  describe "User Story 5 - Merchant Bulk Discount Edit" do
    it "displays a link to edit the Bulk Discount" do 
      expect(page).to have_link("Edit Bulk Discount")
      click_link("Edit Bulk Discount")

      expect(page.current_path).to eq(edit_merchant_bulk_discount_path(@barry, @ten_percent))
    end
  end
end
