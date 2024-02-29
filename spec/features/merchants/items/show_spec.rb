require "rails_helper"

RSpec.describe "Merchant Item Show" do
  before do
    @merchant_1 = Merchant.create!(name: "Barry")

    @yain = Customer.create!(first_name: "Yain", last_name: "Porter")
    @joey = Customer.create!(first_name: "Joey", last_name: "R")
    @jess = Customer.create!(first_name: "Jess", last_name: "K")
    @lance = Customer.create!(first_name: "Lance", last_name: "B")
    @abdul = Customer.create!(first_name: "Abdul", last_name: "R")

    @invoice_1 = Invoice.create!(customer_id: @yain.id, status: 1, created_at: "2021-09-30")
    @invoice_2 = Invoice.create!(customer_id: @joey.id, status: 1, created_at: "2019-10-12")
    @invoice_3 = Invoice.create!(customer_id: @jess.id, status: 1, created_at: "2022-01-11")
    @invoice_4 = Invoice.create!(customer_id: @lance.id, status: 1)
    @invoice_5 = Invoice.create!(customer_id: @abdul.id, status: 1)

    create_list(:transaction, 20, invoice_id: @invoice_5.id)
    create_list(:transaction, 15, invoice_id: @invoice_2.id)
    create_list(:transaction, 10, invoice_id: @invoice_1.id)
    create_list(:transaction, 7, invoice_id: @invoice_3.id)
    create_list(:transaction, 5, invoice_id: @invoice_4.id)

    @item_1 = create(:item, name: "book", merchant: @merchant_1, description: "good book", unit_price: 1000)
    @item_2 = create(:item, name: "belt", merchant: @merchant_1)
    @item_3 = create(:item, name: "shoes", merchant: @merchant_1)
    @item_4 = create(:item, name: "paint", merchant: @merchant_1)

    create(:invoice_item, status: 1, invoice_id: @invoice_1.id, item_id: @item_1.id) #packaged
    create(:invoice_item, status: 1, invoice_id: @invoice_2.id, item_id: @item_2.id) #packaged
    create(:invoice_item, status: 1, invoice_id: @invoice_3.id, item_id: @item_3.id) #packaged
    create(:invoice_item, status: 0, invoice_id: @invoice_4.id, item_id: @item_4.id) #pending
    create(:invoice_item, status: 0, invoice_id: @invoice_5.id, item_id: @item_1.id) #pending

    visit merchant_item_path(@merchant_1, @item_1)
  end

  describe "User Story 7 - Merchant Items Show" do
    it "has a working link from the merchant items index page" do
      visit merchant_items_path(@merchant_1)

      expect(page).to have_link("book")
      expect(page).to have_link("belt")
      expect(page).to have_link("shoes")
      expect(page).to have_link("paint")

      click_on "book"
      expect(page.current_path).to eq(merchant_item_path(@merchant_1, @item_1))
    end
    it "lists all of the item's attributes" do
      expect(page).to have_content("Item: book")
      expect(page).to have_content("Description: good book")
      expect(page).to have_content("Current selling price: $10")
      expect(page).to have_content("Merchant ID: #{@merchant_1.id}")
    end
  end

  describe "User Story 8 - Merchant Item Update Link" do
    it "has link to update item's information" do
      expect(page).to have_link("Update Item")

      click_on "Update Item"
      expect(page.current_path).to eq(edit_merchant_item_path(@merchant_1, @item_1))
    end
  end
end

