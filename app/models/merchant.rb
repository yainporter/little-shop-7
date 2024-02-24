class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates :name, presence: true

  def top_five_customers
    self.transactions.joins(invoice: :customer)
      .where("transactions.result = ?", "0")
      .select("customers.id, CONCAT(customers.first_name,' ', customers.last_name) as full_name, COUNT(transactions) as successful_transactions")
      .group("customers.id")
      .order("successful_transactions DESC")
      .limit(5)
  end
end