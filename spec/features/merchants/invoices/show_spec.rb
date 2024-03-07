require 'rails_helper'

RSpec.describe 'Merchant Invoices Show Page', type: :feature do
  describe 'As a Merchant ' do
    before(:each) do
      @yain = Customer.create!(first_name: "Yain", last_name: "Porter")
      @abdul = Customer.create!(first_name: "Abdul", last_name: "R")

      @merchant_1 = Merchant.create!(name: "Barry")
      @item_1 = create(:item, name: "book", merchant: @merchant_1)
      @item_2 = create(:item, name: "belt", merchant: @merchant_1)

      @invoice_1 = Invoice.create!(customer_id: @yain.id, status: 1, created_at: "2011-09-13")

      @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 2500, status: 0) # pending
      @invoice_item_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 2, unit_price: 1000, status: 1) # packaged
      @invoice_item_3 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 6, unit_price: 1000, status: 1) # packaged

      @merchant_2 = Merchant.create!(name: "Jane")
      @item_3 = create(:item, name: "soda", merchant: @merchant_2)
      @item_4 = create(:item, name: "shoe", merchant: @merchant_2)

      @invoice_2 = Invoice.create!(customer_id: @abdul.id, status: 0, created_at: "2011-09-14")

      @invoice_item_4 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_2.id, quantity: 2, unit_price: 1000, status: 1) # packaged

      visit merchant_invoice_path(@merchant_1, @invoice_1)
    end

    describe "User Story 15 - Listing Invoice Attributes" do
      it "displays all the information related to the Invoice" do
        expect(page).to have_content("Invoice ##{@invoice_1.id}")
        expect(page).to have_content("Status: Completed")
        expect(page).to have_content("Created on: Tuesday, September 13, 2011")
        expect(page).to have_content("Customer: Yain Porter")

        visit merchant_invoice_path(@merchant_2, @invoice_2)

        expect(page).to have_content("Invoice ##{@invoice_2.id}")
        expect(page).to have_content("Status: In Progress")
        expect(page).to have_content("Created on: Wednesday, September 14, 2011")
        expect(page).to have_content("Customer: Abdul R")
      end
    end

    describe "User Story 16 - Invoice Item Information" do
      it "lists all items on the invoice" do
        expect(page).to have_content("Item Name")
        expect(page).to have_content("Quantity")
        expect(page).to have_content("Unit Price")
        expect(page).to have_content("Status")

        within "#invoice_item-#{@invoice_item_1.id}" do
          expect(page).to have_content("book")
          expect(page).to have_content("1")
          expect(page).to have_content("$25.00")
          expect(page).to have_content("Pending")
        end

        within "#invoice_item-#{@invoice_item_2.id}" do
          expect(page).to have_content("belt")
          expect(page).to have_content("2")
          expect(page).to have_content("$10.00")
          expect(page).to have_content("Packaged")
        end

        visit merchant_invoice_path(@merchant_2, @invoice_2)

        within "#invoice_item-#{@invoice_item_4.id}" do
          expect(page).to have_content("soda")
          expect(page).to have_content("2")
          expect(page).to have_content("$10.00")
          expect(page).to have_content("Packaged")
        end
      end
    end

    describe "User Story 17 - Total Revenue" do
      it "displays the total revenue generated from all items" do
        expect(page).to have_content("Total Revenue: $105.00")

        visit merchant_invoice_path(@merchant_2, @invoice_2)

        expect(page).to have_content("Total Revenue: $20.00")
      end
    end

    describe "User Story 18 - Update Item Status" do
      it "displays a select field with current status selected for Items" do
        within "#invoice_item-#{@invoice_item_1.id}" do
          expect(page).to have_select("Status", with_options: ["Pending", "Packaged", "Shipped"])
          expect(page.find_field("Status").value).to eq("Pending")
        end

        within "#invoice_item-#{@invoice_item_2.id}" do
          expect(page).to have_select("Status", with_options: ["Pending", "Packaged", "Shipped"])
          expect(page.find_field("Status").value).to eq("Packaged")
        end
      end

      it "updates each Item's status when I click Submit" do
        within "#invoice_item-#{@invoice_item_1.id}" do
          expect(page.find_field("Status").value).to_not eq("Shipped")

          select "Shipped", from: "Status"
          click_button

          expect(page.current_path).to eq(merchant_invoice_path(@merchant_1.id, @invoice_1))
          expect(page.find_field("Status").value).to eq("Shipped")
        end

        within "#invoice_item-#{@invoice_item_2.id}" do
          expect(page.find_field("Status").value).to_not eq("Pending")

          select "Pending", from: "Status"
          click_button

          expect(page.current_path).to eq(merchant_invoice_path(@merchant_1.id, @invoice_1))
          expect(page.find_field("Status").value).to eq("Pending")
        end
      end
    end

    describe "User Story 6 - Total Revenue and Discounted Revenue" do
      before do
        @barry = Merchant.create!(name: "Barry")

        @ten_percent = BulkDiscount.create!(name: "10% Off", percentage: 10, quantity_threshold: 3, merchant_id: @barry.id)
        @twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 20, quantity_threshold: 5, merchant_id: @barry.id)
        @thirty_percent = BulkDiscount.create!(name: "30% Off", percentage: 30, quantity_threshold: 8, merchant_id: @barry.id)

        @lance = Customer.create!(first_name: "Lance", last_name: "Butler")

        @book = @barry.items.create!(name: "Book", description: "Good book", unit_price: 1500)
        @shoes = @barry.items.create!(name: "Shoes", description: "Good shoes", unit_price: 5000)
        @belt = @barry.items.create!(name: "Belt", description: "Good belt", unit_price: 5000)
        @hat = @barry.items.create!(name: "Hat", description: "Good hat", unit_price: 5000)
        @sunglasses = @barry.items.create!(name: "Sunglasses", description: "Good sunglasses", unit_price: 5000)
        @shirt = @barry.items.create!(name: "Shirt", description: "Good shirt", unit_price: 5000)
        @pants = @barry.items.create!(name: "Pants", description: "Good pants", unit_price: 5000)

        lance_invoice_1 = Invoice.create!(customer_id: @lance.id, status: 0, created_at: "2015-05-05")

        #Invoice 1
        @invoice_item_1 = InvoiceItem.create!(item_id: @book.id, invoice_id: lance_invoice_1.id, quantity: 4, status: 1, unit_price: 1000) #1000*4*0.9 = 3600 - 4000
        @invoice_item_2 = InvoiceItem.create!(item_id: @shoes.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500) # 2500*2 = 5000
        @invoice_item_3 = InvoiceItem.create!(item_id: @hat.id, invoice_id: lance_invoice_1.id, quantity: 6, status: 1, unit_price: 2500) # 2500*6*0.8 = 12000 - 15000
        @invoice_item_4 = InvoiceItem.create!(item_id: @belt.id, invoice_id: lance_invoice_1.id, quantity: 3, status: 1, unit_price: 2500) # 2500*3*0.9 = 6750 - 7500
        @invoice_item_5 = InvoiceItem.create!(item_id: @shoes.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500) # 2500*2 = 5000
        @invoice_item_6 = InvoiceItem.create!(item_id: @pants.id, invoice_id: lance_invoice_1.id, quantity: 9, status: 1, unit_price: 2500) # 2500*9*0.7 = 15750 - 22500
        @invoice_item_7 = InvoiceItem.create!(item_id: @sunglasses.id, invoice_id: lance_invoice_1.id, quantity: 1, status: 1, unit_price: 25000) # 25000

        visit merchant_invoice_path(@barry, lance_invoice_1)
      end
      it "displays total revenue from this invoice not including discounts" do
        expect(page).to have_content("Total Revenue: $840.00")
      end

      it "displays total discounted revenue from this invoice including discounts" do
        expect(page).to have_content("Total Discounted Revenue: $731.00")
      end
    end

    describe "User Story 7 - Link to applied discounts" do
      before do
        @barry = Merchant.create!(name: "Barry")

        @ten_percent = BulkDiscount.create!(name: "10% Off", percentage: 10, quantity_threshold: 3, merchant_id: @barry.id)
        @twenty_percent = BulkDiscount.create!(name: "20% Off", percentage: 20, quantity_threshold: 5, merchant_id: @barry.id)
        @thirty_percent = BulkDiscount.create!(name: "30% Off", percentage: 30, quantity_threshold: 8, merchant_id: @barry.id)

        @lance = Customer.create!(first_name: "Lance", last_name: "Butler")

        @book = @barry.items.create!(name: "Book", description: "Good book", unit_price: 1500)
        @shoes = @barry.items.create!(name: "Shoes", description: "Good shoes", unit_price: 5000)
        @belt = @barry.items.create!(name: "Belt", description: "Good belt", unit_price: 5000)
        @hat = @barry.items.create!(name: "Hat", description: "Good hat", unit_price: 5000)
        @sunglasses = @barry.items.create!(name: "Sunglasses", description: "Good sunglasses", unit_price: 5000)
        @shirt = @barry.items.create!(name: "Shirt", description: "Good shirt", unit_price: 5000)
        @pants = @barry.items.create!(name: "Pants", description: "Good pants", unit_price: 5000)

        lance_invoice_1 = Invoice.create!(customer_id: @lance.id, status: 0, created_at: "2015-05-05")

        #Invoice 1
        @invoice_item_1 = InvoiceItem.create!(item_id: @book.id, invoice_id: lance_invoice_1.id, quantity: 4, status: 1, unit_price: 1000) #1000*4*0.9 = 3600 - 4000
        @invoice_item_2 = InvoiceItem.create!(item_id: @shoes.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500) # 2500*2 = 5000
        @invoice_item_3 = InvoiceItem.create!(item_id: @hat.id, invoice_id: lance_invoice_1.id, quantity: 6, status: 1, unit_price: 2500) # 2500*6*0.8 = 12000 - 15000
        @invoice_item_4 = InvoiceItem.create!(item_id: @belt.id, invoice_id: lance_invoice_1.id, quantity: 3, status: 1, unit_price: 2500) # 2500*3*0.9 = 6750 - 7500
        @invoice_item_5 = InvoiceItem.create!(item_id: @shoes.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500) # 2500*2 = 5000
        @invoice_item_6 = InvoiceItem.create!(item_id: @pants.id, invoice_id: lance_invoice_1.id, quantity: 9, status: 1, unit_price: 2500) # 2500*9*0.7 = 15750 - 22500
        @invoice_item_7 = InvoiceItem.create!(item_id: @sunglasses.id, invoice_id: lance_invoice_1.id, quantity: 1, status: 1, unit_price: 25000)

        visit merchant_invoice_path(@barry, lance_invoice_1)
    end
      it "displays a link next to each invoice_item that has a discount applied" do
      save_and_open_page

        within "#invoice_item-#{@invoice_item_1.id}" do
          expect(page).to have_link("Yes")
          expect(page).to have_no_content("No")
        end

        within "#invoice_item-#{@invoice_item_3.id}" do
          expect(page).to have_link("Yes")
          expect(page).to have_no_content("No")
          click_link
        end

        expect(page.current_path).to eq(merchant_bulk_discount_path(@barry, @twenty_percent))
      end

      it "displays 'No' if there is no discount applied to an invoice_item" do
        within "#invoice_item-#{@invoice_item_2.id}" do
          expect(page).to have_no_link
          expect(page).to have_content("No")
        end

        within "#invoice_item-#{@invoice_item_5.id}" do
          expect(page).to have_no_link
          expect(page).to have_content("No")
        end
      end
    end
  end
end
