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

  # enum status: {"In Progress" => 0, "Completed" => 1, "Cancelled" => 2}
  CSV.foreach(file, headers: true) do |row|
    case row["status"]
    when "in progress"
      row["status"] = 0
    when "completed"
      row["status"] = 1
    when "cancelled"
      row["status"] = 2
    end

    Invoice.create!(row.to_hash)
  end
end

task transactions: :environment do
  file = "db/data/transactions.csv"

  # enum result: {success: 0, failed: 1}
  CSV.foreach(file, headers: true) do |row|
    Transaction.create!(row.to_hash)
    case row["result"]
    when "success"
      row["result"] = 0
    when "failed"
      row["result"] = 1
    end


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

  # enum status: {"Pending" => 0, "Packaged" => 1, "Shipped" => 2}
  CSV.foreach(file, headers: true) do |row|
    case row["status"]
    when "pending"
      row["status"] = 0
    when "packaged"
      row["status"] = 1
    when "shipped"
      row["status"] = 2
    end
    InvoiceItem.create!(row.to_hash)
  end
end

task reset_pk_sequence: :environment do
  ActiveRecord::Base.connection.tables.each do |table_name|
    ActiveRecord::Base.connection.reset_pk_sequence!(table_name)
  end
end
