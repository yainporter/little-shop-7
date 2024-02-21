require 'csv'

task total_destruction: :environment do
  InvoiceItem.destroy_all
  Transaction.destroy_all
  Invoice.destroy_all
  Customer.destroy_all
  Item.destroy_all
  Merchant.destroy_all
end

task all: [:total_destruction, :customers, :invoices, :transactions, :merchants, :items, :invoice_items, :reset_pk_sequence]

task customers: :environment do
  file = "db/data/customers.csv"

  CSV.foreach(file, headers: true) do |row|
    Customer.create!(row.to_hash)
  end
end

task invoices: :environment do
  file = "db/data/invoices.csv"
  
  CSV.foreach(file, headers: true) do |row|
    Invoice.create!(row.to_hash)
  end
end

task transactions: :environment do
  file = "db/data/transactions.csv"

  CSV.foreach(file, headers: true) do |row|
    Transaction.create!(row.to_hash)
  end
end

task merchants: :environment do
  file = "db/data/merchants.csv"
  
  CSV.foreach(file, headers: true) do |row|
    Merchant.create!(row.to_hash)
  end
end

task items: :environment do
  file = "db/data/items.csv"
  
  CSV.foreach(file, headers: true) do |row|
    Item.create!(row.to_hash)
  end
end

task invoice_items: :environment do
  file = "db/data/invoice_items.csv"

  CSV.foreach(file, headers: true) do |row|
    InvoiceItem.create!(row.to_hash)
  end
end

task reset_pk_sequence: :environment do
  ActiveRecord::Base.connection.tables.each do |table_name|
    ActiveRecord::Base.connection.reset_pk_sequence!(table_name)
  end
end