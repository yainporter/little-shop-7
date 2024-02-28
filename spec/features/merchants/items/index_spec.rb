require 'rails_helper'

RSpec.describe 'Merchant Items Index Page', type: :feature do
  describe 'As a Merchant ' do
    before(:each) do
    @merchant_1 = Merchant.create!(name: "Barry")
    @merchant_2 = Merchant.create!(name: "Jane")

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

    create_list(:transaction, 20, invoice_id: @invoice_5.id)
    create_list(:transaction, 15, invoice_id: @invoice_2.id)
    create_list(:transaction, 10, invoice_id: @invoice_1.id)
    create_list(:transaction, 7, invoice_id: @invoice_3.id)
    create_list(:transaction, 5, invoice_id: @invoice_4.id)
    create_list(:transaction, 5, invoice_id: @invoice_6.id)

    @item_1 = create(:item, name: "book", merchant: @merchant_1)
    @item_2 = create(:item, name: "belt", merchant: @merchant_1)
    @item_3 = create(:item, name: "shoes", merchant: @merchant_1)
    @item_4 = create(:item, name: "paint", merchant: @merchant_1)
    @item_5 = create(:item, name: "soda", merchant: @merchant_2)

    create(:invoice_item, status: 1, invoice_id: @invoice_1.id, item_id: @item_1.id) #packaged
    create(:invoice_item, status: 1, invoice_id: @invoice_2.id, item_id: @item_2.id) #packaged
    create(:invoice_item, status: 1, invoice_id: @invoice_3.id, item_id: @item_3.id) #packaged
    create(:invoice_item, status: 0, invoice_id: @invoice_4.id, item_id: @item_4.id) #pending
    create(:invoice_item, status: 0, invoice_id: @invoice_5.id, item_id: @item_1.id) #pending
    create(:invoice_item, status: 0, invoice_id: @invoice_6.id, item_id: @item_5.id) #pending

    visit merchant_items_path(@merchant_1.id)
    end

    describe "User Story-6 Merchant Items Index Page" do
      it 'displays a list of the names of all of the merchants items' do
        expect(page).to have_content("#{@merchant_1.name} Items:")

        within "#item-#{@item_1.id}" do
          expect(page).to have_content("book")
          expect(page).to_not have_content("soda")
        end

        within "#item-#{@item_2.id}" do
          expect(page).to have_content("belt")
          expect(page).to_not have_content("soda")
        end

        within "#item-#{@item_5.id}" do
          expect(page).to have_content("soda")
          expect(page).to_not have_content("book")
        end
      end
    end

    describe "User Story 9 - Merchant Item Disable/Enable" do
      it "displays a button next to each Item to disable or enable the item" do
        @merchant_1.items.each do |item|
          within "#item-#{item.id}" do
            expect(page).to have_content("Item Status: Disabled")
            expect(page).to have_no_content("Item Status: Enabled")
            expect(page).to have_button("Disable")
            expect(page).to have_button("Enable")
          end
        end

        @item_5.update!(status: "Enabled")
        visit merchant_items_path(@merchant_2)

        within "#item-#{@item_5.id}" do
          expect(page).to have_content("Item Status: Enabled")
          expect(page).to have_no_content("Item Status: Disabled")
          expect(page).to have_button("Disable")
          expect(page).to have_button("Enable")
        end
      end

      it "redirects to the index page with updated information when button is clicked" do
        @merchant_1.items.each do |item|
          within "#item-#{item.id}" do
            click_button "Disable"
            expect(page).to have_current_path(merchant_items_path(@merchant_1))
            expect(page).to have_content("Item Status: Disabled")
            expect(page).to have_no_content("Item Status: Enabled")
          end
        end

        @item_5.update!(status: "Enabled")
        visit merchant_items_path(@merchant_2)

        within "#item-#{@item_5.id}" do
          click_button "Enable"
          expect(page).to have_current_path(merchant_items_path(@merchant_2))
          expect(page).to have_content("Item Status: Enabled")
          expect(page).to have_no_content("Item Status: Disabled")
        end
      end
    end

    describe "User Story 10 - Merchant Items Grouped by Status" do
      it "has two sections, and lists the Item in the appropriate section" do
        expect(page).to have_content("Enabled Items")
        expect(page).to have_content("Disabled Items")

        within "#disabled-items" do
          expect(page).to have_content("book")
          expect(page).to have_content("belt")
          expect(page).to have_content("shoes")
          expect(page).to have_content("paint")
        end

        within "#enabled-items" do
          expect(page).to have_no_content("book")
          expect(page).to have_no_content("belt")
          expect(page).to have_no_content("shoes")
          expect(page).to have_no_content("paint")
        end

        @item_4.update!(status: 0)
        @item_3.update!(status: 0)

        visit  merchant_items_path(@merchant_1.id)

        within "#disabled-items" do
          expect(page).to have_content("book")
          expect(page).to have_content("belt")
          expect(page).to have_no_content("shoes")
          expect(page).to have_no_content("paint")
        end

        within "#enabled-items" do
          expect(page).to have_no_content("book")
          expect(page).to have_no_content("belt")
          expect(page).to have_content("shoes")
          expect(page).to have_content("paint")
        end
      end
    end

    describe "User Story 12 - 5 Most Popular Items" do
      before do
        barry = Merchant.create!(name: "Barry")
        lance = Customer.create!(first_name: "Lance", last_name: "Butler")

        book = barry.items.create!(name: "Book", description: "Good book", unit_price: 1500) #Total:
        @shoes = barry.items.create!(name: "Shoes", description: "Good shoes", unit_price: 5000)
        @belt = barry.items.create!(name: "Belt", description: "Good belt", unit_price: 5000)
        @hat = barry.items.create!(name: "Hat", description: "Good hat", unit_price: 5000)
        @sunglasses = barry.items.create!(name: "Sunglasses", description: "Good sunglasses", unit_price: 5000)
        shirt = barry.items.create!(name: "Shirt", description: "Good shirt", unit_price: 5000)
        @pants = barry.items.create!(name: "Pants", description: "Good pants", unit_price: 5000)

        lance_invoice_1 = Invoice.create!(customer_id: lance.id, status: 0, created_at: "2015-05-05")
        lance_invoice_2 = Invoice.create!(customer_id: lance.id, status: 0, created_at: "2014-04-04")
        lance_invoice_3 = Invoice.create!(customer_id: lance.id, status: 0, created_at: "2013-03-03")
        lance_invoice_4 = Invoice.create!(customer_id: lance.id, status: 0, created_at: "2012-02-02")
        lance_invoice_5 = Invoice.create!(customer_id: lance.id, status: 0, created_at: "2011-01-01")


        InvoiceItem.create!(item_id: book.id, invoice_id: lance_invoice_1.id, quantity: 4, status: 1, unit_price: 1000)
        InvoiceItem.create!(item_id: @sunglasses.id, invoice_id: lance_invoice_1.id, quantity: 1, status: 1, unit_price: 25000)
        InvoiceItem.create!(item_id: @shoes.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500)
        InvoiceItem.create!(item_id: @hat.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500)
        InvoiceItem.create!(item_id: @belt.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500)
        InvoiceItem.create!(item_id: @shoes.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500)
        InvoiceItem.create!(item_id: @pants.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500)
        InvoiceItem.create!(item_id: book.id, invoice_id: lance_invoice_2.id, quantity: 3, status: 1, unit_price: 1000)
        InvoiceItem.create!(item_id: @shoes.id, invoice_id: lance_invoice_2.id, quantity: 2, status: 1, unit_price: 2500)
        InvoiceItem.create!(item_id: shirt.id, invoice_id: lance_invoice_2.id, quantity: 1, status: 1, unit_price: 2500)
        InvoiceItem.create!(item_id: @sunglasses.id, invoice_id: lance_invoice_2.id, quantity: 2, status: 1, unit_price: 2500)
        InvoiceItem.create!(item_id: @belt.id, invoice_id: lance_invoice_2.id, quantity: 2, status: 1, unit_price: 2500)
        InvoiceItem.create!(item_id: book.id, invoice_id: lance_invoice_3.id, quantity: 1, status: 1, unit_price: 10000)
        InvoiceItem.create!(item_id: @belt.id, invoice_id: lance_invoice_3.id, quantity: 2, status: 1, unit_price: 25000)
        InvoiceItem.create!(item_id: shirt.id, invoice_id: lance_invoice_3.id, quantity: 2, status: 1, unit_price: 25000)
        InvoiceItem.create!(item_id: @shoes.id, invoice_id: lance_invoice_3.id, quantity: 2, status: 1, unit_price: 25000)
        InvoiceItem.create!(item_id: book.id, invoice_id: lance_invoice_4.id, quantity: 4, status: 1, unit_price: 100000000)
        InvoiceItem.create!(item_id: @shoes.id, invoice_id: lance_invoice_4.id, quantity: 2, status: 1, unit_price: 25000000)
        InvoiceItem.create!(item_id: @pants.id, invoice_id: lance_invoice_5.id, quantity: 4, status: 1, unit_price: 25000)
        InvoiceItem.create!(item_id: @belt.id, invoice_id: lance_invoice_5.id, quantity: 2, status: 1, unit_price: 5000)
        InvoiceItem.create!(item_id: @hat.id, invoice_id: lance_invoice_5.id, quantity: 3, status: 1, unit_price: 25000)

        create(:transaction, invoice: lance_invoice_1, result: "success")
        create(:transaction, invoice: lance_invoice_1, result: "failed")
        create(:transaction, invoice: lance_invoice_1, result: "success")
        create(:transaction, invoice: lance_invoice_2, result: "success")
        create(:transaction, invoice: lance_invoice_2, result: "success")
        create(:transaction, invoice: lance_invoice_2, result: "success")
        create(:transaction, invoice: lance_invoice_2, result: "success")
        create(:transaction, invoice: lance_invoice_2, result: "success")
        create(:transaction, invoice: lance_invoice_2, result: "success")
        create(:transaction, invoice: lance_invoice_3, result: "failed")
        create(:transaction, invoice: lance_invoice_3, result: "failed")
        create(:transaction, invoice: lance_invoice_3, result: "success")
        create(:transaction, invoice: lance_invoice_4, result: "failed")
        create(:transaction, invoice: lance_invoice_4, result: "failed")
        create(:transaction, invoice: lance_invoice_4, result: "failed")
        create(:transaction, invoice: lance_invoice_4, result: "failed")
        create(:transaction, invoice: lance_invoice_5, result: "success")
        create(:transaction, invoice: lance_invoice_5, result: "success")

        visit merchant_items_path(barry.id)
      end

      it "lists the names of the top 5 items ranked by revenue generated" do
        within "#top-5-items" do
          items = page.all('li')

          expect(items[0]).to have_text("Pants - $2,100.00 in sales")
          expect(items[1]).to have_text("Hat - $1,600.00 in sales")
          expect(items[2]).to have_text("Belt - $1,100.00 in sales")
          expect(items[3]).to have_text("Shoes - $1,000.00 in sales")
          expect(items[4]).to have_text("Sunglasses - $800.00 in sales")
        end

        within "#top-item-#{@pants.id}" do
          expect(page).to have_content("Top day for Pants was 1/1/11")
        end
        within "#top-item-#{@hat.id}" do
          expect(page).to have_content("Top day for Hat was 1/1/11")
        end
        within "#top-item-#{@belt.id}" do
          expect(page).to have_content("Top day for Belt was 3/3/13")
        end
        within "#top-item-#{@shoes.id}" do
          expect(page).to have_content("Top day for Shoes was 3/3/13")
        end
        within "#top-item-#{@sunglasses.id}" do
          expect(page).to have_content("Top day for Sunglasses was 5/5/15")
        end
      end
    end
  end
end
