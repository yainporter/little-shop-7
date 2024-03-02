require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index', type: :feature do
  describe 'As a Merchant ' do
    before do
      @barry = Merchant.create!(name: "@Barry")
      @lance = Customer.create!(first_name: "Lance", last_name: "Butler")

      @book = @barry.items.create!(name: "Book", description: "Good book", unit_price: 1500)
      @shoes = @barry.items.create!(name: "Shoes", description: "Good shoes", unit_price: 5000)
      @belt = @barry.items.create!(name: "Belt", description: "Good belt", unit_price: 5000)
      @hat = @barry.items.create!(name: "Hat", description: "Good hat", unit_price: 5000)
      @sunglasses = @barry.items.create!(name: "Sunglasses", description: "Good sunglasses", unit_price: 5000)
      @shirt = @barry.items.create!(name: "Shirt", description: "Good shirt", unit_price: 5000)
      @pants = @barry.items.create!(name: "Pants", description: "Good pants", unit_price: 5000)

      lance_invoice_1 = Invoice.create!(customer_id: @lance.id, status: 0, created_at: "2015-05-05")
      lance_invoice_2 = Invoice.create!(customer_id: @lance.id, status: 0, created_at: "2014-04-04")
      lance_invoice_3 = Invoice.create!(customer_id: @lance.id, status: 0, created_at: "2013-03-03")
      lance_invoice_4 = Invoice.create!(customer_id: @lance.id, status: 0, created_at: "2012-02-02")
      #Invoice 1
      InvoiceItem.create!(item_id: @book.id, invoice_id: lance_invoice_1.id, quantity: 4, status: 1, unit_price: 1000)
      InvoiceItem.create!(item_id: @shoes.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500)
      InvoiceItem.create!(item_id: @hat.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500)
      InvoiceItem.create!(item_id: @belt.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500)
      InvoiceItem.create!(item_id: @shoes.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500)
      InvoiceItem.create!(item_id: @pants.id, invoice_id: lance_invoice_1.id, quantity: 2, status: 1, unit_price: 2500)
      InvoiceItem.create!(item_id: @sunglasses.id, invoice_id: lance_invoice_1.id, quantity: 1, status: 1, unit_price: 25000)
      create(:transaction, invoice: lance_invoice_1, result: "success")
      create(:transaction, invoice: lance_invoice_1, result: "failed")
      create(:transaction, invoice: lance_invoice_1, result: "success")
      #Invoice 2
      InvoiceItem.create!(item_id: @book.id, invoice_id: lance_invoice_2.id, quantity: 3, status: 1, unit_price: 1000)
      InvoiceItem.create!(item_id: @shoes.id, invoice_id: lance_invoice_2.id, quantity: 2, status: 1, unit_price: 2500)
      InvoiceItem.create!(item_id: @shirt.id, invoice_id: lance_invoice_2.id, quantity: 1, status: 1, unit_price: 2500)
      InvoiceItem.create!(item_id: @sunglasses.id, invoice_id: lance_invoice_2.id, quantity: 2, status: 1, unit_price: 2500)
      InvoiceItem.create!(item_id: @belt.id, invoice_id: lance_invoice_2.id, quantity: 2, status: 1, unit_price: 2500)
      create(:transaction, invoice: lance_invoice_2, result: "success")
      create(:transaction, invoice: lance_invoice_2, result: "success")
      create(:transaction, invoice: lance_invoice_2, result: "success")
      create(:transaction, invoice: lance_invoice_2, result: "success")
      create(:transaction, invoice: lance_invoice_2, result: "success")
      create(:transaction, invoice: lance_invoice_2, result: "success")
      #Invoice 3
      InvoiceItem.create!(item_id: @book.id, invoice_id: lance_invoice_3.id, quantity: 1, status: 1, unit_price: 10000)
      InvoiceItem.create!(item_id: @belt.id, invoice_id: lance_invoice_3.id, quantity: 2, status: 1, unit_price: 25000)
      InvoiceItem.create!(item_id: @shirt.id, invoice_id: lance_invoice_3.id, quantity: 2, status: 1, unit_price: 25000)
      InvoiceItem.create!(item_id: @shoes.id, invoice_id: lance_invoice_3.id, quantity: 2, status: 1, unit_price: 25000)
      create(:transaction, invoice: lance_invoice_3, result: "failed")
      create(:transaction, invoice: lance_invoice_3, result: "failed")
      create(:transaction, invoice: lance_invoice_3, result: "success")
      #Invoice 4
      InvoiceItem.create!(item_id: @book.id, invoice_id: lance_invoice_4.id, quantity: 4, status: 1, unit_price: 100000000)
      InvoiceItem.create!(item_id: @shoes.id, invoice_id: lance_invoice_4.id, quantity: 2, status: 1, unit_price: 25000000)
      create(:transaction, invoice: lance_invoice_4, result: "failed")
      create(:transaction, invoice: lance_invoice_4, result: "failed")
      create(:transaction, invoice: lance_invoice_4, result: "failed")
      create(:transaction, invoice: lance_invoice_4, result: "failed")
      #Invoice 5
      lance_invoice_5 = Invoice.create!(customer_id: @lance.id, status: 0, created_at: "2011-01-01")
      InvoiceItem.create!(item_id: @pants.id, invoice_id: lance_invoice_5.id, quantity: 4, status: 1, unit_price: 25000)
      InvoiceItem.create!(item_id: @belt.id, invoice_id: lance_invoice_5.id, quantity: 2, status: 1, unit_price: 5000)
      InvoiceItem.create!(item_id: @hat.id, invoice_id: lance_invoice_5.id, quantity: 3, status: 1, unit_price: 25000)
      create(:transaction, invoice: lance_invoice_5, result: "success")
      create(:transaction, invoice: lance_invoice_5, result: "success")

      @ten_percent = @barry.bulk_discounts.create!(type: "10% Off", percentage: 0.1, quantity_threshold: 10)
    end
  end
  describe "User Story 1 - Index Setup" do
    it "lists all bulk discounts with their discount and quantity threshold along with link to the show page" do
      
    end
  end
end
