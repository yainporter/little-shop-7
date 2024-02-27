require 'rails_helper'

RSpec.describe 'Merchant Invoices Show Page', type: :feature do
  describe 'As a Merchant ' do
    before(:each) do
      @yain = Customer.create!(first_name: "Yain", last_name: "Porter")
      @abdul = Customer.create!(first_name: "Abdul", last_name: "R")

      @merchant_1 = Merchant.create!(name: "Barry")
      @item_1 = create(:item, name: "book", merchant: @merchant_1)
      @invoice_1 = Invoice.create!(customer_id: @yain.id, status: 1, created_at: "2011-09-13")
      create(:invoice_item, status: 1, invoice_id: @invoice_1.id, item_id: @item_1.id)

      @merchant_2 = Merchant.create!(name: "Jane")
      @item_5 = create(:item, name: "soda", merchant: @merchant_2)
      @invoice_6 = Invoice.create!(customer_id: @abdul.id, status: 0, created_at: "2011-09-14")
      create(:invoice_item, status: 0, invoice_id: @invoice_6.id, item_id: @item_5.id)

      visit merchant_invoice_path(@merchant_1, @invoice_1)
    end

    describe "User Story 15 - Listing Invoice Attributes" do
      it "displays all the information related to the Invoice" do
        expect(page).to have_content("Invoice ##{@invoice_1.id}")
        expect(page).to have_content("Status: Completed")
        expect(page).to have_content("Created on: Tuesday, September 13, 2011")
        expect(page).to have_content("Customer: Yain Porter")

        visit merchant_invoice_path(@merchant_2, @invoice_6)

        expect(page).to have_content("Invoice ##{@invoice_6.id}")
        expect(page).to have_content("Status: In Progress")
        expect(page).to have_content("Created on: Wednesday, September 14, 2011")
        expect(page).to have_content("Customer: Abdul R")
      end
    end
  end
end
