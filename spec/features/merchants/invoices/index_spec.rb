require 'rails_helper'

RSpec.describe 'Merchant Invoices Index Page', type: :feature do
  describe 'As a Merchant ' do
    before(:each) do
      @merchant_1 = Merchant.create!(name: "Barry")

      @item_1 = create(:item, name: "book", merchant: @merchant_1)
      @item_2 = create(:item, name: "belt", merchant: @merchant_1)
      @item_3 = create(:item, name: "shoes", merchant: @merchant_1)
      @item_4 = create(:item, name: "paint", merchant: @merchant_1)

      @merchant_2 = Merchant.create!(name: "Jane")
      @item_5 = create(:item, name: "soda", merchant: @merchant_2)

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
      @invoice_6 = Invoice.create!(customer_id: @abdul.id, status: 1)

      # Barry's Invoices
      create(:invoice_item, status: 1, invoice_id: @invoice_1.id, item_id: @item_1.id) #packaged
      create(:invoice_item, status: 1, invoice_id: @invoice_2.id, item_id: @item_2.id) #packaged
      create(:invoice_item, status: 1, invoice_id: @invoice_3.id, item_id: @item_3.id) #packaged
      create(:invoice_item, status: 0, invoice_id: @invoice_4.id, item_id: @item_4.id) #pending
      create(:invoice_item, status: 0, invoice_id: @invoice_5.id, item_id: @item_1.id) #pending
      # Barry's Transactions
      create_list(:transaction, 20, invoice_id: @invoice_5.id)
      create_list(:transaction, 15, invoice_id: @invoice_2.id)
      create_list(:transaction, 10, invoice_id: @invoice_1.id)
      create_list(:transaction, 7, invoice_id: @invoice_3.id)
      create_list(:transaction, 5, invoice_id: @invoice_4.id)

      # Jane's Invoices
      create(:invoice_item, status: 0, invoice_id: @invoice_6.id, item_id: @item_5.id) #pending
      # Jane's Transactions
      create_list(:transaction, 5, invoice_id: @invoice_6.id)

      visit  merchant_invoices_path(@merchant_1.id)
    end

    describe "User Story 14 - Merchant Invoices Index" do
      it "displays all invoices that include at least one of my merchant's items" do
        expect(page).to have_content("All of Barry's Invoices")

        @merchant_1.items.each do |item|
          expect(page).to have_content("Invoices for #{item.name}:")
        end

        @merchant_1.invoices.each do |invoice|
          within "#invoice-#{invoice.id}" do
            expect(page).to have_content("Invoice ##{invoice.id}")
          end
        end
      end

      it "displays the invoice id for each invoice listed as a link to it's show page" do
        @merchant_1.invoices.each do |invoice|
          within "#invoice-#{invoice.id}" do
            expect(page).to have_link("##{invoice.id}")

            click_link "##{invoice.id}"

            expect(page.current_path).to eq(merchant_invoice_path(@merchant_1, invoice))
            expect(page).to have_current_path(merchant_invoice_path(@merchant_1, invoice))

            visit merchant_invoices_path(@merchant_1.id)
          end
        end
      end
    end
  end
end
