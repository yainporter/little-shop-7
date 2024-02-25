require "rails_helper"

RSpec.describe "Admin Invoices Show", type: :feature do
  describe "As a admin" do
    before do
      @merchant_1 = create(:merchant)

      @item_1 = create(:item, name: "shoes", merchant: @merchant_1)
      @item_2 = create(:item, name: "books", merchant: @merchant_1)
      @item_3 = create(:item, name: "lamp", merchant: @merchant_1)

      @customer_1 = Customer.create!(first_name: "Lance", last_name: "B")
      @customer_2 = Customer.create!(first_name: "Jess", last_name: "K")

      @invoice_1 = @customer_1.invoices.create!(status: 1, created_at: "2011-09-13")
      @invoice_2 = @customer_2.invoices.create!(status: 2, created_at: "2022-03-08")

      @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 2500, status: 0) # pending
      @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 2, unit_price: 1000, status: 1) # packaged
      @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 3, unit_price: 100000, status: 2) # shipped

      # unit_price
        # price sold at -> invoice_items
        # current sales price -> item
    end

    describe "User Story 33 - Admin Invoice Show page" do
      it "list invoice attributes" do
        visit admin_invoice_path(@invoice_1)

        expect(page).to have_content(@invoice_1.id)
        expect(page).to have_content("Completed")
        expect(page).to have_content("Tuesday, September 13, 2011")
        expect(page).to_not have_content(@invoice_2.id)
        expect(page).to_not have_content("Cancelled")
        expect(page).to_not have_content("Tuesday, March 08, 2022")
      end

      it "has customers first and last name" do
        visit admin_invoice_path(@invoice_1)

        expect(page).to have_content("Lance B")
        expect(page).to_not have_content("Jess K")
      end
    end

    describe "User Story 34 - Invoice Item Information" do
      it "lists invoice's items and their info" do
        within "#item-#{@item_1.id}" do
          expect(page).to have_content("shoes")   # item name
          expect(page).to have_content("1")       # quantity ordered
          expect(page).to have_content("$15")     # sold at
          expect(page).to have_content("Pending") # status
        end

        within "#item-#{@item_2.id}" do
          expect(page).to have_content("shoes")
          expect(page).to have_content("2")
          expect(page).to have_content("$15")
          expect(page).to have_content("Pending")
        end

        within "#item-#{@item_3.id}" do
          expect(page).to have_content("shoes")
          expect(page).to have_content("3")
          expect(page).to have_content("$15")
          expect(page).to have_content("Pending")
        end
      end
    end
  end
end