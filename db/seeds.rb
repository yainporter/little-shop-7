# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
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

20.times do
  Transaction.create!(credit_card_number: Faker::Business.credit_card_number, credit_card_expiration_date: Faker::Business.credit_card_expiry_date, invoice_id: @invoice_5.id, result: 0)
end
15.times do
  Transaction.create!(credit_card_number: Faker::Business.credit_card_number, credit_card_expiration_date: Faker::Business.credit_card_expiry_date, invoice_id: @invoice_2.id, result: 0)
end
10.times do
  Transaction.create!(credit_card_number: Faker::Business.credit_card_number, credit_card_expiration_date: Faker::Business.credit_card_expiry_date, invoice_id: @invoice_1.id, result: 0)
end
7.times do
  Transaction.create!(credit_card_number: Faker::Business.credit_card_number, credit_card_expiration_date: Faker::Business.credit_card_expiry_date, invoice_id: @invoice_3.id, result: 0)
end
5.times do
  Transaction.create!(credit_card_number: Faker::Business.credit_card_number, credit_card_expiration_date: Faker::Business.credit_card_expiry_date, invoice_id: @invoice_4.id, result: 0)
end


@item_1 = Item.create!(name: "book", merchant: @merchant_1, description: "lalala", unit_price: 110000)
@item_2 = Item.create!(name: "belt", merchant: @merchant_1, description: "lalala", unit_price: 110000)
@item_3 = Item.create!(name: "shoes", merchant: @merchant_1, description: "lalala", unit_price: 110000)
@item_4 = Item.create!(name: "paint", merchant: @merchant_1, description: "lalala", unit_price: 110000)

InvoiceItem.create!(quantity: 2, unit_price: 10000, status: 1, item_id: @item_1.id, invoice_id: @invoice_1.id)
InvoiceItem.create!(quantity: 2, unit_price: 10000, status: 1, item_id: @item_2.id, invoice_id: @invoice_2.id)
InvoiceItem.create!(quantity: 2, unit_price: 10000, status: 1, item_id: @item_3.id, invoice_id: @invoice_3.id)
InvoiceItem.create!(quantity: 2, unit_price: 10000, status: 0, item_id: @item_4.id, invoice_id: @invoice_4.id)
InvoiceItem.create!(quantity: 2, unit_price: 10000, status: 0, item_id: @item_1.id, invoice_id: @invoice_5.id)
