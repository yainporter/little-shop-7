require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index', type: :feature do
  before do
    @barry = Merchant.create!(name: "Barry")
    @ten_percent = BulkDiscount.create!(name: "10% Off", percentage: 10, quantity_threshold: 3, merchant_id: @barry.id)
    @twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 20, quantity_threshold: 5, merchant_id: @barry.id)
    @thirty_percent = BulkDiscount.create!(name: "30% Off", percentage: 30, quantity_threshold: 8, merchant_id: @barry.id)

    visit merchant_bulk_discounts_path(@barry)
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

  describe "User Story 2 - Merchant Bulk Discount Create" do
    it "displays a link to create a new discount" do
      expect(page).to have_link("Create New Discount")

      click_link("Create New Discount")

      expect(page.current_path).to eq(new_merchant_bulk_discount_path(@barry))
    end
  end

  describe "User Story 3 - Merchant Bulk Discount Delete" do
    it "has a button next to each discount to delete it" do
      @barry.bulk_discounts.each do |bulk_discount|
        within "#discount-#{bulk_discount.id}" do
          expect(page).to have_button("Delete Discount")
        end
      end
    end

    it "deletes the discount when clicked" do
      within "#discount-#{@thirty_percent.id}" do
        click_button
      end

      expect(page.current_path).to eq(merchant_bulk_discounts_path(@barry))
      expect(page).to have_no_css("ul#discount-#{@thirty_percent.id}")
      expect(page).to have_no_content("30% Off")
      expect(page).to have_no_content("Discount: 30% Off")
      expect(page).to have_no_content("Quantity Threshold: 8")
    end
  end
end
