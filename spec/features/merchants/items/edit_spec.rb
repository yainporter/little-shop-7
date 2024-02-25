require "rails_helper"

RSpec.describe "Merchant Item Edit" do
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

    visit edit_merchant_item_path(@merchant_1, @item_1)
  end

  describe "User Story 8 - Merchant Item Update" do
    it "has a form filled in with the existing attribute information" do
      save_and_open_page
      expect(page).to have_field(placeholder: "#{@item_1.id}")
      expect(page).to have_field(placeholder: "#{@item_1.merchant_id}")
      expect(page).to have_field(placeholder: "good book")
      expect(page).to have_field(placeholder: "book")
      expect(page).to have_field(placeholder: "1000")
      expect(page).to have_content("Update")
    end

    it "redirects to the Merchant Item Show page after being updated" do
      fill_in :description, with "Stormlight Archive"
      fill_in :name, with "The Way of Kings"

      click_button
      expect(page.current_path).to eq(merchant_item_path(@merchant_1, @item_1))
      expect(page).to have_content("Congratulations! You've edited the item successfully!")
      expect(page).to have_content("Stormlight")
    end
  end
end
