require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Edit Page', type: :feature do
  before do
    @barry = Merchant.create!(name: "Barry")
    @ten_percent = BulkDiscount.create!(name: "10% Off", percentage: 10, quantity_threshold: 3, merchant_id: @barry.id)

    visit edit_merchant_bulk_discount_path(@barry, @ten_percent)
  end

  describe "User Story 5 - Merchant Bulk Discount Edit" do
    it "has a form to edit the Bulk Discount already prefilled" do
      expect(page).to have_css("form")
      expect(page).to have_field(:bulk_discount_name, with: "10% Off")
      expect(page).to have_field(:bulk_discount_percentage, with: 10)
      expect(page).to have_field(:bulk_discount_quantity_threshold, with: 3)
      expect(page).to have_button("Update")
    end

    it "redirects to the show page when updated" do
      fill_in(:bulk_discount_name, with: "50% Off")
      fill_in(:bulk_discount_percentage, with: 50)
      fill_in(:bulk_discount_quantity_threshold, with: 15)
      click_button("Update")

      expect(page.current_path).to eq(merchant_bulk_discount_path(@barry, @ten_percent))
      expect(page).to have_content("50% Off Stats")
      expect(page).to have_content("Discount: 50%")
      expect(page).to have_content("Quantity Threshold: 15")
    end
  end
end
