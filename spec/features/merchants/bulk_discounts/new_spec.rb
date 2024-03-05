require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index', type: :feature do
  before do
    @barry = Merchant.create!(name: "Barry")
  end

  describe "User Story 2 - Merchant Bulk Discount Create" do
    it "has a form to add a new bulk discount" do
      visit new_merchant_bulk_discount_path(@barry)

      expect(page).to have_content("Create A New Discount For Barry")
      expect(page).to have_field(:bulk_discount_name)
      expect(page).to have_field(:bulk_discount_percentage)
      expect(page).to have_field(:bulk_discount_quantity_threshold)
      expect(page).to have_button("Submit")
    end

    it "redirects to index after submitting" do
      visit merchant_bulk_discounts_path(@barry)

      expect(page).to have_no_content("50% Off")

      visit new_merchant_bulk_discount_path(@barry)

      fill_in(:bulk_discount_name, with: "50% Off")
      fill_in(:bulk_discount_percentage, with: 50)
      fill_in(:bulk_discount_quantity_threshold, with: 10)
      click_button

      expect(page.current_path).to eq(merchant_bulk_discounts_path(@barry))
      expect(page).to have_content("50% Off")
      expect(page).to have_content("New Bulk Discount made successfully!")
    end

    it "has a sad path that redirects to new_merchant_bulk_discount_path" do
      visit new_merchant_bulk_discount_path(@barry)
      click_button

      expect(page).to have_content("Make sure all fields are filled in")
    end
  end
end
