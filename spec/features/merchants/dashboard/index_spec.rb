require "rails_helper"

RSpec.describe "Merchant Dashboard" do
  before do
    @merchant_1 = Merchant.create!(name: "Barry")

    @yain = Customer.create!(first_name: "Yain", last_name: "Porter")
    @joey = Customer.create!(first_name: "Joey", last_name: "R")
    @jess = Customer.create!(first_name: "Jess", last_name: "K")
    @lance = Customer.create!(first_name: "Lance", last_name: "B")
    @abdul = Customer.create!(first_name: "Abdul", last_name: "R")

    @invoice_1 = Invoice.create!(customer_id: @yain.id, status: 1)
    @invoice_2 = Invoice.create!(customer_id: @joey.id, status: 1)
    @invoice_3 = Invoice.create!(customer_id: @jess.id, status: 1)
    @invoice_4 = Invoice.create!(customer_id: @lance.id, status: 1)
    @invoice_5 = Invoice.create!(customer_id: @abdul.id, status: 1)

    create_list(:transaction, 20, invoice_id: @invoice_5.id)
    create_list(:transaction, 15, invoice_id: @invoice_2.id)
    create_list(:transaction, 10, invoice_id: @invoice_1.id)
    create_list(:transaction, 7, invoice_id: @invoice_3.id)
    create_list(:transaction, 5, invoice_id: @invoice_4.id)

    @item_1 = create(:item, merchant: @merchant_1)

    create(:invoice_item, invoice_id: @invoice_1.id, item_id: @item_1.id)
    create(:invoice_item, invoice_id: @invoice_2.id, item_id: @item_1.id)
    create(:invoice_item, invoice_id: @invoice_3.id, item_id: @item_1.id)
    create(:invoice_item, invoice_id: @invoice_4.id, item_id: @item_1.id)
    create(:invoice_item, invoice_id: @invoice_5.id, item_id: @item_1.id)

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

  describe "User Story 3 - Top 5 Customers" do
    it "displays names of the top five customers with successful transactions" do 
      within "#top-five-customers" do
        expect("Abdul").to appear_before("Joey")
        expect("Joey").to appear_before("Yain")
        expect("Yain").to appear_before("Jess")
        expect("Jess").to appear_before("Lance")
      end
    end

    it "displays the number of successful transactions next to each customer" do
      expect(page).to have_content("Customer Name: Abdul R Successful Transactions: 20")
      expect(page).to have_content("Customer Name: Joey R Successful Transactions: 15")
      expect(page).to have_content("Customer Name: Yain Porter Successful Transactions: 10")
      expect(page).to have_content("Customer Name: Jess K Successful Transactions: 7")
      expect(page).to have_content("Customer Name: Lance B Successful Transactions: 5")
    end
  end
end
